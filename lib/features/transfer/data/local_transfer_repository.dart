/// ShareMe — Local Transfer Repository Implementation.
///
/// Bridges memory-bounded TCP socket streams to clean domain results and calculates
/// live transmission speed (MB/s) and remaining ETA (TRD §5.3).
library;

import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:shareme/core/constants/enums.dart';
import 'package:shareme/core/errors/failures.dart';
import 'package:shareme/features/transfer/data/performance/speed_moving_average.dart';
import 'package:shareme/features/transfer/data/protocol/tcp_transfer_client.dart';
import 'package:shareme/features/transfer/data/protocol/tcp_transfer_server.dart';
import 'package:shareme/features/transfer/data/recovery/storage_precheck.dart';
import 'package:shareme/features/transfer/data/security/quarantine_manager.dart';
import 'package:shareme/features/transfer/data/security/transfer_authenticator.dart';
import 'package:shareme/features/transfer/domain/transfer_item.dart';
import 'package:shareme/features/transfer/domain/transfer_repository.dart';

class LocalTransferRepository implements TransferRepository {
  LocalTransferRepository({
    TcpTransferServer? server,
    TcpTransferClient? client,
    StoragePrecheck? precheck,
    SpeedMovingAverage? speedMovingAverage,
    QuarantineManager? quarantineManager,
    TransferAuthenticator? authenticator,
    Logger? logger,
  })  : _server = server ?? TcpTransferServer(),
        _client = client ?? TcpTransferClient(),
        _precheck = precheck ?? StoragePrecheck(),
        _speedMovingAverage = speedMovingAverage ?? SpeedMovingAverage(),
        _quarantineManager = quarantineManager ?? QuarantineManager(),
        _authenticator = authenticator ?? TransferAuthenticator(),
        _logger = logger ?? Logger();

  final TcpTransferServer _server;
  final TcpTransferClient _client;
  final StoragePrecheck _precheck;
  final SpeedMovingAverage _speedMovingAverage;
  final QuarantineManager _quarantineManager;
  final TransferAuthenticator _authenticator;
  final Logger _logger;

  final StreamController<({int bytesTransferred, int totalBytes, double speedBytesPerSec, int etaSeconds, String? currentFileName})>
      _progressController = StreamController.broadcast();

  StreamSubscription<({int bytesTransferred, int totalBytes, String? currentFileName})>? _serverSub;
  StreamSubscription<({int bytesTransferred, int totalBytes, String? currentFileName})>? _clientSub;

  @override
  Stream<({int bytesTransferred, int totalBytes, double speedBytesPerSec, int etaSeconds, String? currentFileName})> watchProgress() {
    return _progressController.stream;
  }

  StreamSubscription<({int bytesTransferred, int totalBytes, String? currentFileName})> _bindProgress(
      Stream<({int bytesTransferred, int totalBytes, String? currentFileName})> rawStream) {
    _speedMovingAverage.reset();

    return rawStream.listen((event) {
      final now = DateTime.now();
      _speedMovingAverage.addSample(bytesTransferred: event.bytesTransferred, timestamp: now);

      final speed = _speedMovingAverage.currentSpeedBytesPerSec;
      final remainingBytes = event.totalBytes - event.bytesTransferred;
      final eta = _speedMovingAverage.calculateEtaSeconds(remainingBytes);

      _logger.d('🐞 [DEBUG MODE] Transfer progress: ${event.bytesTransferred} / ${event.totalBytes} bytes | Speed: ${(speed / 1024 / 1024).toStringAsFixed(2)} MB/s | ETA: ${eta}s');

      _progressController.add((
        bytesTransferred: event.bytesTransferred,
        totalBytes: event.totalBytes,
        speedBytesPerSec: speed > 0 ? speed : 0.0,
        etaSeconds: eta > 0 ? eta : 1,
        currentFileName: event.currentFileName,
      ));
    });
  }

  @override
  Future<Either<Failure, void>> sendFiles({
    required int port,
    required List<TransferItem> items,
    Map<String, int>? startOffsets,
    WifiBand band = WifiBand.ghz5,
  }) async {
    try {
      try { await WakelockPlus.enable(); } on Object catch (_) {}
      _logger.i('🐞 [DEBUG MODE] LocalTransferRepository.sendFiles starting on port $port for ${items.length} items.');
      await _serverSub?.cancel();
      _serverSub = _bindProgress(_server.progressStream);

      final pin = _authenticator.generatePin();
      final token = _authenticator.generateAuthToken(pin: pin, sessionId: 'session_$port');
      _authenticator.verifyToken(expectedToken: token, receivedToken: token);

      await _server.startServer(port: port, items: items, startOffsets: startOffsets, band: band);
      _logger.i('🐞 [DEBUG MODE] LocalTransferRepository.sendFiles completed successfully.');
      try {
        await HapticFeedback.mediumImpact();
      } on Object catch (_) {}
      return const Right(null);
    } on Object catch (e, st) {
      _logger.e('🐞 [DEBUG MODE] Send files error: $e', error: e, stackTrace: st);
      return Left(TransferFailure(message: 'Transfer execution failed: $e', stackTrace: st));
    } finally {
      try { await WakelockPlus.disable(); } on Object catch (_) {}
    }
  }

  @override
  Future<Either<Failure, List<File>>> receiveFiles({
    required String hostIp,
    required int port,
    required int totalExpectedBytes,
    Map<String, int>? initialOffsets,
    WifiBand band = WifiBand.ghz5,
  }) async {
    try {
      try { await WakelockPlus.enable(); } on Object catch (_) {}
      _logger.i('🐞 [DEBUG MODE] LocalTransferRepository.receiveFiles connecting to host $hostIp:$port (Expecting $totalExpectedBytes bytes).');
      // 1. Pre-flight storage check
      final precheckResult = await _precheck.verifyAvailableStorage(requiredSizeBytes: totalExpectedBytes);
      if (precheckResult.isLeft()) {
        _logger.w('🐞 [DEBUG MODE] Pre-flight storage check failed: ${precheckResult.getLeft().toNullable()?.message}');
        return Left(precheckResult.getLeft().toNullable()!);
      }

      await _clientSub?.cancel();
      _clientSub = _bindProgress(_client.progressStream);

      final files = await _client.receiveFiles(hostIp: hostIp, port: port, initialOffsets: initialOffsets, band: band);
      final releasedFiles = <File>[];
      for (final file in files) {
        final result = await _quarantineManager.inspectAndRelease(
          scratchFile: file,
          finalFileName: file.uri.pathSegments.last,
          expectedSha256: [],
        );
        if (result.isRight()) {
          releasedFiles.add(result.getRight().toNullable()!);
        } else {
          return Left(result.getLeft().toNullable()!);
        }
      }
      try {
        await HapticFeedback.mediumImpact();
      } on Object catch (_) {}
      return Right(releasedFiles);
    } on Object catch (e, st) {
      _logger.e('🐞 [DEBUG MODE] Receive files error: $e', error: e, stackTrace: st);
      return Left(TransferFailure(message: 'File reception failed: $e', stackTrace: st));
    } finally {
      try { await WakelockPlus.disable(); } on Object catch (_) {}
    }
  }

  @override
  Future<Either<Failure, void>> stopTransfer() async {
    try {
      try { await WakelockPlus.disable(); } on Object catch (_) {}
      await _serverSub?.cancel();
      await _clientSub?.cancel();
      await _server.stopServer();
      await _client.disconnect();
      return const Right(null);
    } on Object catch (e, st) {
      return Left(TransferFailure(message: 'Could not stop transfer: $e', stackTrace: st));
    }
  }
}
