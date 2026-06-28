/// ShareMe — Application State Providers.
///
/// Manages real live permissions, device naming, native file picking,
/// peer scanning, and active TCP transfer sessions. Pure live data.
library;

import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

import '../../features/discovery/domain/peer_device.dart';
import '../../features/discovery/presentation/providers/discovery_providers.dart';
import '../../features/home/domain/history_item.dart';
import '../../features/pairing/presentation/providers/pairing_providers.dart';
import '../../features/transfer/domain/transfer_item.dart';
import '../../features/transfer/domain/transfer_session.dart';
import '../../features/transfer/presentation/providers/transfer_providers.dart';
import '../../features/transfer/data/hotspot/hotspot_data_source.dart';
import '../../features/transfer/domain/hotspot_state.dart';
import '../data/local/local_storage_providers.dart';

// Hotspot Data Source Provider
final hotspotDataSourceProvider = Provider<HotspotDataSource>((ref) {
  return HotspotDataSource();
});

// ==========================================
// 1. Permissions State Provider
// ==========================================

class PermissionsNotifier extends Notifier<bool> {
  @override
  bool build() {
    unawaited(checkPermissions());
    return false;
  }

  Future<void> checkPermissions() async {
    final wifi = await Permission.nearbyWifiDevices.status;
    final location = await Permission.location.status;
    final storage = await Permission.storage.status;
    final manage = await Permission.manageExternalStorage.status;

    final isGranted = (wifi.isGranted || location.isGranted) && (storage.isGranted || manage.isGranted);
    if (state != isGranted) {
      state = isGranted;
    }
  }

  Future<void> requestPermissions() async {
    await [
      Permission.nearbyWifiDevices,
      Permission.location,
      Permission.storage,
      Permission.manageExternalStorage,
      Permission.photos,
      Permission.videos,
      Permission.audio,
    ].request();

    await checkPermissions();
    if (!state) {
      final wifi = await Permission.nearbyWifiDevices.status;
      final location = await Permission.location.status;
      if (wifi.isGranted || location.isGranted) {
        state = true;
      }
    }
  }

  Future<void> requestWifiAndLocation() async {
    await [Permission.nearbyWifiDevices, Permission.location].request();
    await checkPermissions();
  }

  Future<void> requestStorage() async {
    await [
      Permission.storage,
      Permission.manageExternalStorage,
      Permission.photos,
      Permission.videos,
      Permission.audio,
    ].request();
    await checkPermissions();
  }

  void grantAll() {
    unawaited(requestPermissions());
  }
}

final permissionsGrantedProvider =
    NotifierProvider<PermissionsNotifier, bool>(PermissionsNotifier.new);

// ==========================================
// 2. Local Device Name Provider
// ==========================================

class DeviceNameNotifier extends Notifier<String> {
  @override
  String build() {
    ref.listen(deviceDisplayNameProvider, (prev, next) {
      if (next.value != null) {
        state = next.value!;
      }
    });

    final settingsAsync = ref.read(deviceDisplayNameProvider);
    return settingsAsync.value ?? 'ShareMe Mobile';
  }

  void updateName(String newName) {
    state = newName;
    ref.read(settingsRepositoryProvider).updateDeviceName(newName);
  }
}

final localDeviceNameProvider =
    NotifierProvider<DeviceNameNotifier, String>(DeviceNameNotifier.new);

// ==========================================
// 3. Transfer History List Provider
// ==========================================

final transferHistoryListProvider = Provider<List<HistoryItem>>((ref) {
  final asyncVal = ref.watch(recentTransfersProvider);
  return asyncVal.value ?? [];
});

// ==========================================
// 4. Device Files Provider (Real File Picker)
// ==========================================

class DeviceFilesNotifier extends Notifier<List<TransferItem>> {
  @override
  List<TransferItem> build() => const [];

  Future<void> browseDeviceFiles() async {
    final result = await FilePicker.pickFiles(allowMultiple: true);
    if (result != null && result.files.isNotEmpty) {
      final newItems = result.files.where((f) => f.path != null).map((f) {
        return TransferItem(
          id: const Uuid().v4(),
          name: f.name,
          sizeBytes: f.size,
          path: f.path,
          mimeType: _inferMimeType(f.name),
        );
      }).toList();

      state = [...state, ...newItems];
    }
  }

  void removeFile(String id) {
    state = state.where((item) => item.id != id).toList();
  }

  void clearAll() => state = const [];

  String _inferMimeType(String filename) {
    final ext = filename.split('.').last.toLowerCase();
    switch (ext) {
      case 'mp4':
      case 'mkv':
      case 'avi':
      case 'mov':
        return 'video/$ext';
      case 'pdf':
        return 'application/pdf';
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'webp':
        return 'image/$ext';
      case 'apk':
        return 'application/vnd.android.package-archive';
      case 'mp3':
      case 'flac':
      case 'wav':
        return 'audio/$ext';
      case 'zip':
      case 'rar':
      case '7z':
        return 'application/zip';
      default:
        return 'application/octet-stream';
    }
  }
}

final deviceFilesProvider =
    NotifierProvider<DeviceFilesNotifier, List<TransferItem>>(DeviceFilesNotifier.new);

// ==========================================
// 5. Selected Files List Provider
// ==========================================

class SelectedFilesNotifier extends Notifier<List<TransferItem>> {
  @override
  List<TransferItem> build() => const [];

  void toggle(TransferItem item) {
    if (state.any((i) => i.id == item.id)) {
      state = state.where((i) => i.id != item.id).toList();
    } else {
      state = [...state, item];
    }
  }

  void selectAll() {
    state = ref.read(deviceFilesProvider);
  }

  void clear() => state = const [];
}

final selectedFilesListProvider =
    NotifierProvider<SelectedFilesNotifier, List<TransferItem>>(SelectedFilesNotifier.new);

// ==========================================
// 6. Real Peer Discovery Provider
// ==========================================

class DiscoveryState {
  const DiscoveryState({required this.isScanning, required this.peers});
  final bool isScanning;
  final List<PeerDevice> peers;
}

class DiscoveryNotifier extends Notifier<DiscoveryState> {
  @override
  DiscoveryState build() {
    ref.onDispose(() {
      try {
        ref.read(discoveryRepositoryProvider).stopDiscovery();
      } on Object catch (_) {}
    });

    final myName = ref.watch(localDeviceNameProvider).trim().toLowerCase();
    final nativePeersAsync = ref.watch(nearbyPeersStreamProvider);
    final nativePeers = (nativePeersAsync.value ?? [])
        .where((p) => p.name.trim().toLowerCase() != myName)
        .toList();
    return DiscoveryState(isScanning: stateOrNull?.isScanning ?? false, peers: nativePeers);
  }

  Future<void> startScanning() async {
    state = const DiscoveryState(isScanning: true, peers: []);

    // Gate until real device name is loaded from SQLite settings DB
    var deviceName = ref.read(localDeviceNameProvider);
    if (deviceName == 'ShareMe Mobile') {
      try {
        final asyncName = await ref.read(deviceDisplayNameProvider.future);
        if (asyncName.isNotEmpty) deviceName = asyncName;
      } on Object catch (_) {}
    }

    // Get persistent install UUID
    var uuid = '';
    try {
      uuid = await ref.read(installUuidProvider.future);
    } on Object catch (_) {}

    try {
      await ref.read(discoveryRepositoryProvider).startDiscovery(
        deviceName: deviceName,
        uuid: uuid,
      );
    } on Object catch (_) {}
  }

  void stopScanning() {
    state = DiscoveryState(isScanning: false, peers: state.peers);
    try {
      ref.read(discoveryRepositoryProvider).stopDiscovery();
    } on Object catch (_) {}
  }
}

final peerDiscoveryProvider =
    NotifierProvider<DiscoveryNotifier, DiscoveryState>(DiscoveryNotifier.new);

// ==========================================
// 7. Live Active Transfer Session Provider
// ==========================================

class TransferNotifier extends Notifier<TransferSession?> {
  StreamSubscription<({int bytesTransferred, int totalBytes, double speedBytesPerSec, int etaSeconds, String? currentFileName})>? _progressSub;
  DateTime? _startTime;

  @override
  TransferSession? build() {
    ref.onDispose(() {
      _progressSub?.cancel();
    });
    return null;
  }

  Future<void> startPairing(PeerDevice peer) async {
    debugPrint('🐞 [DEBUG MODE] startPairing initiated with target peer: ${peer.name} (ID/IP: ${peer.id})');
    _startTime = DateTime.now();
    await _progressSub?.cancel();

    final items = ref.read(selectedFilesListProvider);
    if (items.isEmpty) {
      debugPrint('🐞 [DEBUG MODE] No items selected to send. Redirecting to startReceiving mode.');
      await startReceiving(peer);
      return;
    }

    final totalBytes = items.fold<int>(0, (sum, item) => sum + item.sizeBytes);
    debugPrint('🐞 [DEBUG MODE] Preparing session payload: ${items.length} items totaling $totalBytes bytes.');

    state = TransferSession(
      sessionId: const Uuid().v4(),
      peerDevice: peer,
      items: items,
      totalBytes: totalBytes,
    );

    final senderName = ref.read(localDeviceNameProvider);
    try {
      debugPrint('🐞 [DEBUG MODE] Executing pairing negotiation via pairingRepository...');
      await ref.read(pairingRepositoryProvider).negotiatePairing(
            peer: peer,
            items: items,
            senderName: senderName,
          );
      debugPrint('🐞 [DEBUG MODE] Pairing negotiation completed successfully.');
    } on Object catch (e) {
      debugPrint('🐞 [DEBUG MODE] Pairing negotiation threw exception: $e');
    }

    if (state != null && state!.status == TransferSessionStatus.connecting) {
      debugPrint('🐞 [DEBUG MODE] Session confirmed in connecting state. Creating Hotspot...');
      final hotspotDs = ref.read(hotspotDataSourceProvider);
      
      // We don't await this completely because it may take seconds and we can proceed based on stream
      unawaited(hotspotDs.createHotspot());

      // Wait for it to be ready (which means the AP is up)
      await for (final hotspotState in hotspotDs.watchHotspotState()) {
        if (hotspotState.status == HotspotStatus.creating || hotspotState.status == HotspotStatus.connected) {
          debugPrint('🐞 [DEBUG MODE] Hotspot created. Launching TCP transfer server on port 0...');
          await _beginTransfer();
          break;
        } else if (hotspotState.status == HotspotStatus.failed) {
          debugPrint('🐞 [DEBUG MODE] Hotspot creation failed. Aborting transfer.');
          state = state!.copyWith(status: TransferSessionStatus.failed, errorMessage: hotspotState.errorMessage);
          break;
        }
      }
    }
  }

  Future<void> startReceiving(PeerDevice peer) async {
    debugPrint('🐞 [DEBUG MODE] startReceiving initiated with sender: ${peer.name} (ID/IP: ${peer.id})');
    _startTime = DateTime.now();
    await _progressSub?.cancel();

    const totalExpectedBytes = 100 * 1024 * 1024; // Baseline estimated size until negotiated

    state = TransferSession(
      sessionId: const Uuid().v4(),
      peerDevice: peer,
      items: const [
        TransferItem(id: 'rx_1', name: 'Waiting for sender files...', sizeBytes: totalExpectedBytes, mimeType: 'application/octet-stream')
      ],
      isSent: false,
      totalBytes: totalExpectedBytes,
    );

    _listenToRealProgress();

    final hotspotDs = ref.read(hotspotDataSourceProvider);
    var hostIp = peer.id.contains('.') ? peer.id : '192.168.49.1';

    if (peer.p2pAddress != null && peer.p2pAddress!.isNotEmpty) {
      debugPrint('🐞 [DEBUG MODE] Connecting to Hotspot via P2P Address: ${peer.p2pAddress}');
      unawaited(hotspotDs.connectToHotspot(peer.p2pAddress!));
      
      await for (final hotspotState in hotspotDs.watchHotspotState()) {
        if (hotspotState.status == HotspotStatus.connected) {
          hostIp = hotspotState.groupOwnerIp ?? '192.168.49.1';
          debugPrint('🐞 [DEBUG MODE] Hotspot connected. GO IP is: $hostIp');
          break;
        } else if (hotspotState.status == HotspotStatus.failed) {
          debugPrint('🐞 [DEBUG MODE] Hotspot connection failed. Aborting transfer.');
          state = state!.copyWith(status: TransferSessionStatus.failed, errorMessage: hotspotState.errorMessage);
          return;
        }
      }
    }

    debugPrint('🐞 [DEBUG MODE] Connecting TCP receiver socket to host IP: $hostIp on port 8888...');
    try {
      unawaited(ref.read(transferRepositoryProvider).receiveFiles(
            hostIp: hostIp,
            port: 8888,
            totalExpectedBytes: totalExpectedBytes,
          ).then((result) {
            hotspotDs.destroyHotspot(); // Clean up hotspot connection
            result.fold(
              (failure) => debugPrint('🐞 [DEBUG MODE] receiveFiles failed: ${failure.message}'),
              (files) {
                debugPrint('🐞 [DEBUG MODE] receiveFiles succeeded! Received ${files.length} files.');
                if (state != null) {
                  final receivedItems = files.map((f) {
                    final name = f.uri.pathSegments.last;
                    var size = 0;
                    try { size = f.lengthSync(); } on Object catch (_) {}
                    return TransferItem(
                      id: name,
                      name: name,
                      sizeBytes: size,
                      mimeType: 'application/octet-stream',
                      progress: 1.0,
                      status: TransferItemStatus.completed,
                    );
                  }).toList();
                  final totalSize = receivedItems.fold<int>(0, (sum, i) => sum + i.sizeBytes);
                  state = state!.copyWith(
                    items: receivedItems.isNotEmpty ? receivedItems : state!.items,
                    totalBytes: totalSize > 0 ? totalSize : state!.totalBytes,
                    transferredBytes: totalSize > 0 ? totalSize : state!.transferredBytes,
                  );
                }
              },
            );
          }));
    } on Object catch (e) {
      debugPrint('🐞 [DEBUG MODE] receiveFiles threw unhandled exception: $e');
    }
  }

  void _listenToRealProgress() {
    debugPrint('🐞 [DEBUG MODE] Binding real progress stream listener...');
    _progressSub = ref.read(transferRepositoryProvider).watchProgress().listen((event) {
      if (state == null) return;

      final newTransferred = event.bytesTransferred;
      final speed = event.speedBytesPerSec > 0 ? event.speedBytesPerSec : 1.0;
      final etaSec = event.etaSeconds > 0 ? event.etaSeconds : 1;
      final elapsed = _startTime != null ? DateTime.now().difference(_startTime!).inSeconds : 1;
      final validElapsed = elapsed > 0 ? elapsed : 1;

      var currentTotalBytes = state!.totalBytes;
      var currentItems = state!.items;

      if (!state!.isSent && event.currentFileName != null && event.totalBytes > 0) {
        currentTotalBytes = event.totalBytes;
        if (currentItems.length == 1 && currentItems.first.id == 'rx_1') {
          currentItems = [
            TransferItem(
              id: event.currentFileName!,
              name: event.currentFileName!,
              sizeBytes: event.totalBytes,
              mimeType: 'application/octet-stream',
            )
          ];
        }
      }

      var bytesLeftToDistribute = newTransferred;
      final updatedItems = currentItems.map((item) {
        if (bytesLeftToDistribute >= item.sizeBytes) {
          bytesLeftToDistribute -= item.sizeBytes;
          return item.copyWith(progress: 1.0, status: TransferItemStatus.completed);
        } else if (bytesLeftToDistribute > 0) {
          final p = bytesLeftToDistribute / item.sizeBytes;
          bytesLeftToDistribute = 0;
          return item.copyWith(progress: p, status: TransferItemStatus.transferring);
        } else {
          return item.copyWith(progress: 0.0, status: TransferItemStatus.pending);
        }
      }).toList();

      if (newTransferred >= currentTotalBytes && currentTotalBytes > 0) {
        debugPrint('🐞 [DEBUG MODE] Transfer reached 100% completion ($newTransferred / $currentTotalBytes bytes). Logging success!');
        _progressSub?.cancel();
        
        // Clean up hotspot if we are the sender
        if (state!.isSent) {
          ref.read(hotspotDataSourceProvider).destroyHotspot();
        }
        
        state = state!.copyWith(
          status: TransferSessionStatus.completed,
          transferredBytes: currentTotalBytes,
          totalBytes: currentTotalBytes,
          items: updatedItems,
          speedBytesPerSec: speed,
          elapsedSeconds: validElapsed,
          etaSeconds: 0,
        );
        ref.read(historyRepositoryProvider).logTransferSession(state!);
        ref.read(selectedFilesListProvider.notifier).clear();
      } else {
        state = state!.copyWith(
          status: TransferSessionStatus.transferring,
          transferredBytes: newTransferred,
          totalBytes: currentTotalBytes,
          items: updatedItems,
          speedBytesPerSec: speed,
          elapsedSeconds: validElapsed,
          etaSeconds: etaSec,
        );
      }
    });
  }

  Future<void> _beginTransfer() async {
    if (state == null) return;

    debugPrint('🐞 [DEBUG MODE] _beginTransfer transitioning state to transferring...');
    state = state!.copyWith(
      status: TransferSessionStatus.transferring,
      speedBytesPerSec: 0.0,
    );

    _listenToRealProgress();

    debugPrint('🐞 [DEBUG MODE] Starting sendFiles on port 8888 for ${state!.items.length} items...');
    try {
      unawaited(ref.read(transferRepositoryProvider).sendFiles(
            port: 8888,
            items: state!.items,
          ).then((result) {
            result.fold(
              (failure) => debugPrint('🐞 [DEBUG MODE] sendFiles failed: ${failure.message}'),
              (_) => debugPrint('🐞 [DEBUG MODE] sendFiles completed successfully.'),
            );
          }));
    } on Object catch (e) {
      debugPrint('🐞 [DEBUG MODE] sendFiles threw exception: $e');
    }
  }

  void retryTransfer() {
    debugPrint('🐞 [DEBUG MODE] Retrying transfer session...');
    if (state != null) {
      state = state!.copyWith(status: TransferSessionStatus.connecting, errorMessage: null);
      unawaited(_beginTransfer());
    }
  }

  void cancelTransfer() {
    debugPrint('🐞 [DEBUG MODE] Transfer cancelled by user or screen termination.');
    _progressSub?.cancel();
    if (state != null) {
      state = state!.copyWith(status: TransferSessionStatus.failed, errorMessage: 'Transfer cancelled by user.');
      ref.read(historyRepositoryProvider).logTransferSession(state!);
    }
    ref.read(selectedFilesListProvider.notifier).clear();
    try {
      ref.read(transferRepositoryProvider).stopTransfer();
    } on Object catch (_) {}
  }
}

final activeTransferSessionProvider =
    NotifierProvider<TransferNotifier, TransferSession?>(TransferNotifier.new);
