/// ShareMe — Transfer Recovery Manager.
///
/// Records interrupted byte offsets and coordinates resumable file transfers
/// (TRD §6.1: Automatic Connection Drop Recovery & Resume Handshake).
library;

import 'package:logger/logger.dart';

class TransferRecoveryManager {
  TransferRecoveryManager({Logger? logger}) : _logger = logger ?? Logger();

  final Logger _logger;
  final Map<String, ({int offset, DateTime timestamp})> _checkpoints = {};

  /// Save current byte offset checkpoint for an interrupted file transfer.
  void saveCheckpoint({required String fileId, required int offset}) {
    if (offset <= 0) return;
    _checkpoints[fileId] = (offset: offset, timestamp: DateTime.now());
    _logger.i('Checkpoint recorded for file $fileId at byte offset $offset');
  }

  /// Retrieve last valid byte offset checkpoint for [fileId].
  ///
  /// Expires checkpoints older than 30 minutes per TRD §6.1.
  int getCheckpoint(String fileId) {
    final record = _checkpoints[fileId];
    if (record == null) return 0;

    final ageMinutes = DateTime.now().difference(record.timestamp).inMinutes;
    if (ageMinutes > 30) {
      _logger.w('Checkpoint expired for file $fileId (${ageMinutes}m old). Restarting from 0.');
      _checkpoints.remove(fileId);
      return 0;
    }

    _logger.i('Resuming file $fileId from byte offset ${record.offset}');
    return record.offset;
  }

  /// Remove recorded checkpoint after successful transfer completion or cancellation.
  void clearCheckpoint(String fileId) {
    if (_checkpoints.containsKey(fileId)) {
      _checkpoints.remove(fileId);
      _logger.i('Cleared recovery checkpoint for file $fileId');
    }
  }

  /// Clear all stored checkpoints.
  void clearAll() {
    _checkpoints.clear();
  }
}
