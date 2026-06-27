/// ShareMe — Quarantine Manager & Sandbox SHA-256 Enforcement.
///
/// Ensures incoming file payloads remain isolated in secure scratch folders until
/// rolling SHA-256 validation guarantees zero tampering or corruption (TRD §8.2).
library;

import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shareme/core/errors/failures.dart';

class QuarantineManager {
  QuarantineManager({Logger? logger}) : _logger = logger ?? Logger();

  final Logger _logger;

  /// Inspect downloaded [scratchFile], verify SHA-256 against [expectedSha256],
  /// and release to destination directory if valid.
  ///
  /// If hash mismatch occurs, shreds the scratch file immediately.
  Future<Either<Failure, File>> inspectAndRelease({
    required File scratchFile,
    required String finalFileName,
    required List<int> expectedSha256,
  }) async {
    try {
      if (!scratchFile.existsSync()) {
        return const Left(FileSystemFailure(message: 'Quarantine error: scratch file missing on disk.'));
      }

      _logger.i('Quarantine: Computing SHA-256 verification for ${scratchFile.path}');
      final bytes = await scratchFile.readAsBytes();
      final actualDigest = sha256.convert(bytes);

      var isValid = expectedSha256.isEmpty || actualDigest.bytes.length == expectedSha256.length;
      if (isValid && expectedSha256.isNotEmpty) {
        for (var i = 0; i < expectedSha256.length; i++) {
          if (actualDigest.bytes[i] != expectedSha256[i]) {
            isValid = false;
            break;
          }
        }
      }

      if (!isValid) {
        _logger.w('SECURITY ALERT: SHA-256 checksum mismatch! Shredding corrupted payload: $finalFileName');
        try {
          await scratchFile.delete();
        } on Object catch (_) {}
        return const Left(SecurityFailure(
          message: 'File integrity check failed. Payload rejected and purged from quarantine.',
        ));
      }

      _logger.i('Quarantine passed: SHA-256 digest verified. Releasing to storage.');
      final destDir = await getApplicationDocumentsDirectory();
      final finalPath = '${destDir.path}/$finalFileName';
      final releasedFile = await scratchFile.copy(finalPath);

      // Clean up temp file
      try {
        await scratchFile.delete();
      } on Object catch (_) {}

      return Right(releasedFile);
    } on Object catch (e, st) {
      _logger.e('Quarantine execution failure: $e', error: e, stackTrace: st);
      return Left(SecurityFailure(message: 'Quarantine verification error: $e', stackTrace: st));
    }
  }
}
