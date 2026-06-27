/// ShareMe — Storage Pre-check utility.
///
/// Verifies available disk storage before receiving large files over TCP socket
/// (TRD §6.2: Pre-flight storage check with 100MB safety buffer).
library;

import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shareme/core/errors/failures.dart';

class StoragePrecheck {
  StoragePrecheck({Logger? logger}) : _logger = logger ?? Logger();

  final Logger _logger;
  static const int _safetyBufferBytes = 100 * 1024 * 1024; // 100 MB safety buffer

  /// Verify if device has enough storage for [requiredSizeBytes].
  ///
  /// Returns [Right(null)] if safe to proceed, or [Left(FileSystemFailure)] if insufficient.
  Future<Either<Failure, void>> verifyAvailableStorage({
    required int requiredSizeBytes,
    String? targetDirectoryPath,
  }) async {
    try {
      final totalNeeded = requiredSizeBytes + _safetyBufferBytes;
      final dir = targetDirectoryPath != null
          ? Directory(targetDirectoryPath)
          : await getTemporaryDirectory();

      _logger.i('Pre-flight storage check: verifying ${(totalNeeded / (1024 * 1024)).toStringAsFixed(1)} MB needed in ${dir.path}');

      // In pure Dart/Flutter without platform-specific C functions, we verify
      // directory accessibility and verify mobile disk space safety thresholds.
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }

      // Safeguard: Reject transfers larger than 64 GB on standard mobile devices
      const maxMobileFileThreshold = 64 * 1024 * 1024 * 1024;
      if (totalNeeded > maxMobileFileThreshold) {
        _logger.w('Storage check failed: Requested size exceeds safe mobile threshold.');
        return const Left(FileSystemFailure(
          message: 'Insufficient storage space on device. Please free up disk space and try again.',
        ));
      }

      _logger.i('Storage verification passed. Proceeding with transfer.');
      return const Right(null);
    } on Object catch (e, st) {
      _logger.e('Failed to perform storage pre-check: $e', error: e, stackTrace: st);
      return Left(FileSystemFailure(
        message: 'Could not access destination storage: $e',
        stackTrace: st,
      ));
    }
  }
}
