/// ShareMe — Local History Repository Implementation.
///
/// Bridges domain history requests to Drift SQLite DAO operations.
library;

import 'package:fpdart/fpdart.dart';
import 'package:shareme/core/data/local/app_database.dart';
import 'package:shareme/core/data/local/daos/history_dao.dart';
import 'package:shareme/core/errors/failures.dart';
import 'package:shareme/features/history/domain/history_repository.dart';
import 'package:shareme/features/home/domain/history_item.dart';
import 'package:shareme/features/transfer/domain/transfer_session.dart';

class LocalHistoryRepository implements HistoryRepository {
  LocalHistoryRepository(this._dao);

  final HistoryDao _dao;

  @override
  Stream<Either<Failure, List<HistoryItem>>> watchRecentTransfers() {
    return _dao.watchAllTransfers().map((records) {
      try {
        final items = records
            .map(
              (r) => HistoryItem(
                id: r.id,
                peerName: r.peerName,
                fileCount: r.fileCount,
                totalSizeBytes: r.totalBytes,
                timestampEpochMs: r.timestampEpochMs,
                isSent: r.isSent,
                isSuccess: r.status == 'completed',
              ),
            )
            .toList();
        return Right<Failure, List<HistoryItem>>(items);
      } on Object catch (e, st) {
        return Left<Failure, List<HistoryItem>>(
          StorageFailure(message: 'Failed to parse database records: $e', stackTrace: st),
        );
      }
    });
  }

  @override
  Future<Either<Failure, void>> logTransferSession(TransferSession session) async {
    try {
      final transferRecord = TransferRecord(
        id: session.sessionId,
        peerName: session.peerDevice.name,
        totalBytes: session.totalBytes,
        fileCount: session.items.length,
        timestampEpochMs: DateTime.now().millisecondsSinceEpoch,
        isSent: true, // Default to sent for outgoing flow
        status: session.status.name,
        durationSeconds: session.elapsedSeconds,
      );

      final fileRecords = session.items
          .map(
            (f) => TransferFileRecord(
              id: f.id,
              transferId: session.sessionId,
              fileName: f.name,
              sizeBytes: f.sizeBytes,
              mimeType: f.mimeType,
              storagePath: '/storage/emulated/0/ShareMe/${f.name}',
            ),
          )
          .toList();

      await _dao.insertTransferSession(transferRecord, fileRecords);
      return const Right(null);
    } on Object catch (e, st) {
      return Left(
        StorageFailure(message: 'Failed to write transfer log to SQLite: $e', stackTrace: st),
      );
    }
  }

  @override
  Future<Either<Failure, void>> clearHistory() async {
    try {
      await _dao.clearAllHistory();
      return const Right(null);
    } on Object catch (e, st) {
      return Left(
        StorageFailure(message: 'Failed to clear database history: $e', stackTrace: st),
      );
    }
  }
}
