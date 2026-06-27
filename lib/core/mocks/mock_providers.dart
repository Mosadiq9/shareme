/// ShareMe — Mock state providers for M1 UI testing.
///
/// Simulates permissions, peer scanning, file selection, and live transfers
/// without requiring native WiFi Direct / mDNS / SQLite hardware integration.
library;

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../features/discovery/domain/peer_device.dart';
import '../../features/home/domain/history_item.dart';
import '../../features/transfer/domain/transfer_item.dart';
import '../../features/transfer/domain/transfer_session.dart';

// ==========================================
// 1. Mock Permissions Provider
// ==========================================

class PermissionsNotifier extends Notifier<bool> {
  @override
  bool build() => false; // Starts un-granted so user can see Splash -> Permissions flow!

  void grantAll() => state = true;
  void revokeAll() => state = false;
}

final mockPermissionsProvider =
    NotifierProvider<PermissionsNotifier, bool>(PermissionsNotifier.new);

// ==========================================
// 2. Mock Device Settings Provider
// ==========================================

class DeviceNameNotifier extends Notifier<String> {
  @override
  String build() => 'Pixel 8 Pro (Mosadik)';

  void updateName(String newName) {
    if (newName.trim().isNotEmpty) {
      state = newName.trim();
    }
  }
}

final mockDeviceNameProvider =
    NotifierProvider<DeviceNameNotifier, String>(DeviceNameNotifier.new);

// ==========================================
// 3. Mock Transfer History Provider
// ==========================================

final mockHistoryProvider = Provider<List<HistoryItem>>((ref) {
  final now = DateTime.now().millisecondsSinceEpoch;
  return [
    HistoryItem(
      id: 'hist_1',
      peerName: 'iPhone 15 Pro',
      fileCount: 12,
      totalSizeBytes: 342 * 1024 * 1024, // 342 MB
      timestampEpochMs: now - (15 * 60 * 1000), // 15m ago
      isSent: true,
      isSuccess: true,
    ),
    HistoryItem(
      id: 'hist_2',
      peerName: 'Galaxy S24 Ultra',
      fileCount: 1,
      totalSizeBytes: 1850 * 1024 * 1024, // 1.85 GB (Video)
      timestampEpochMs: now - (3 * 3600 * 1000), // 3h ago
      isSent: false,
      isSuccess: true,
    ),
    HistoryItem(
      id: 'hist_3',
      peerName: 'MacBook Air M3',
      fileCount: 4,
      totalSizeBytes: 45 * 1024 * 1024, // 45 MB
      timestampEpochMs: now - (86400 * 1000), // Yesterday
      isSent: true,
      isSuccess: false,
    ),
  ];
});

// ==========================================
// 4. Mock Available Files (File Picker)
// ==========================================

final mockAvailableFilesProvider = Provider<List<TransferItem>>((ref) {
  return const [
    TransferItem(
      id: 'file_1',
      name: 'Vacation_Video_4K_60fps.mp4',
      sizeBytes: 1250 * 1024 * 1024, // 1.25 GB
      mimeType: 'video/mp4',
    ),
    TransferItem(
      id: 'file_2',
      name: 'Project_Design_System_v2.pdf',
      sizeBytes: 24 * 1024 * 1024, // 24 MB
      mimeType: 'application/pdf',
    ),
    TransferItem(
      id: 'file_3',
      name: 'Sunset_Beach_HDR.jpg',
      sizeBytes: 8 * 1024 * 1024, // 8 MB
      mimeType: 'image/jpeg',
    ),
    TransferItem(
      id: 'file_4',
      name: 'ShareMe_v1.0.0_release.apk',
      sizeBytes: 48 * 1024 * 1024, // 48 MB
      mimeType: 'application/vnd.android.package-archive',
    ),
    TransferItem(
      id: 'file_5',
      name: 'Podcast_Episode_42_Lossless.flac',
      sizeBytes: 110 * 1024 * 1024, // 110 MB
      mimeType: 'audio/flac',
    ),
    TransferItem(
      id: 'file_6',
      name: 'Source_Code_Backup_2026.zip',
      sizeBytes: 310 * 1024 * 1024, // 310 MB
      mimeType: 'application/zip',
    ),
  ];
});

// ==========================================
// 5. Mock Selected Files Provider
// ==========================================

class SelectedFilesNotifier extends Notifier<List<TransferItem>> {
  @override
  List<TransferItem> build() => [
        // Default select first two items for quick testing
        ref.read(mockAvailableFilesProvider)[0],
        ref.read(mockAvailableFilesProvider)[2],
      ];

  void toggleSelection(TransferItem item) {
    if (state.any((e) => e.id == item.id)) {
      state = state.where((e) => e.id != item.id).toList();
    } else {
      state = [...state, item];
    }
  }

  void selectAll() {
    state = List.from(ref.read(mockAvailableFilesProvider));
  }

  void clear() => state = [];
}

final mockSelectedFilesProvider =
    NotifierProvider<SelectedFilesNotifier, List<TransferItem>>(
        SelectedFilesNotifier.new);

// ==========================================
// 6. Mock Discovery / Radar Provider
// ==========================================

class DiscoveryState {
  const DiscoveryState({
    required this.isScanning,
    required this.peers,
  });

  final bool isScanning;
  final List<PeerDevice> peers;
}

class DiscoveryNotifier extends Notifier<DiscoveryState> {
  Timer? _scanTimer;

  @override
  DiscoveryState build() {
    ref.onDispose(() => _scanTimer?.cancel());
    return const DiscoveryState(isScanning: false, peers: []);
  }

  void startScanning() {
    _scanTimer?.cancel();
    state = const DiscoveryState(isScanning: true, peers: []);

    // Simulate 2 second sweep finding nearby peers
    _scanTimer = Timer(const Duration(seconds: 2), () {
      state = const DiscoveryState(
        isScanning: false,
        peers: [
          PeerDevice(
            id: 'peer_1',
            name: 'iPhone 15 Pro Max',
            deviceModel: 'iOS 18.2 • Bonjour',
            signalStrengthRssi: -45,
            supportedBands: ['5GHz', '2.4GHz'],
            is5GhzSupported: true,
          ),
          PeerDevice(
            id: 'peer_2',
            name: 'Galaxy S24 Ultra',
            deviceModel: 'Android 15 • WiFi Direct',
            signalStrengthRssi: -52,
            supportedBands: ['5GHz', '6GHz'],
            is5GhzSupported: true,
          ),
          PeerDevice(
            id: 'peer_3',
            name: 'Redmi Note 13',
            deviceModel: 'Android 14 • WiFi Direct',
            signalStrengthRssi: -68,
            supportedBands: ['2.4GHz'],
          ),
        ],
      );
    });
  }

  void stopScanning() {
    _scanTimer?.cancel();
    state = DiscoveryState(isScanning: false, peers: state.peers);
  }
}

final mockDiscoveryProvider =
    NotifierProvider<DiscoveryNotifier, DiscoveryState>(DiscoveryNotifier.new);

// ==========================================
// 7. Mock Live Transfer Session Provider
// ==========================================

class TransferNotifier extends Notifier<TransferSession?> {
  Timer? _progressTimer;

  @override
  TransferSession? build() {
    ref.onDispose(() => _progressTimer?.cancel());
    return null;
  }

  void startPairing(PeerDevice peer) {
    _progressTimer?.cancel();
    final items = ref.read(mockSelectedFilesProvider);
    final totalBytes = items.fold<int>(0, (sum, item) => sum + item.sizeBytes);

    state = TransferSession(
      sessionId: const Uuid().v4(),
      peerDevice: peer,
      items: items,
      totalBytes: totalBytes,
    );

    // Simulate 2 seconds of handshake / band negotiation
    Timer(const Duration(milliseconds: 1800), () {
      if (state != null && state!.status == TransferSessionStatus.connecting) {
        _beginTransfer();
      }
    });
  }

  void _beginTransfer() {
    if (state == null) return;

    state = state!.copyWith(
      status: TransferSessionStatus.transferring,
      speedBytesPerSec: 45.2 * 1024 * 1024, // 45.2 MB/s
    );

    const tickMs = 200;
    final bytesPerTick = (state!.speedBytesPerSec * (tickMs / 1000)).toInt();

    _progressTimer = Timer.periodic(const Duration(milliseconds: tickMs), (timer) {
      if (state == null || state!.status != TransferSessionStatus.transferring) {
        timer.cancel();
        return;
      }

      final newTransferred =
          (state!.transferredBytes + bytesPerTick).clamp(0, state!.totalBytes);
      final remainingBytes = state!.totalBytes - newTransferred;
      final etaSec = (remainingBytes / state!.speedBytesPerSec).ceil();
      final elapsedSec = state!.elapsedSeconds + (tickMs == 1000 ? 1 : 0);

      // Update individual item progress
      var bytesLeftToDistribute = newTransferred;
      final updatedItems = state!.items.map((item) {
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

      if (newTransferred >= state!.totalBytes) {
        timer.cancel();
        state = state!.copyWith(
          status: TransferSessionStatus.completed,
          transferredBytes: state!.totalBytes,
          items: updatedItems,
          etaSeconds: 0,
        );
      } else {
        state = state!.copyWith(
          transferredBytes: newTransferred,
          items: updatedItems,
          etaSeconds: etaSec,
          elapsedSeconds: elapsedSec,
        );
      }
    });
  }

  void simulateFailure() {
    _progressTimer?.cancel();
    if (state != null) {
      state = state!.copyWith(
        status: TransferSessionStatus.failed,
        errorMessage: 'Connection lost on 5GHz High-Speed band. Peer disconnected.',
      );
    }
  }

  void retryTransfer() {
    if (state != null) {
      startPairing(state!.peerDevice);
    }
  }

  void cancelTransfer() {
    _progressTimer?.cancel();
    state = null;
  }
}

final mockTransferProvider =
    NotifierProvider<TransferNotifier, TransferSession?>(TransferNotifier.new);
