/// ShareMe — Drift DAO: History Accessor.
///
/// Handles relational queries and batch transactions for transfer sessions and associated files.
library;

import 'package:drift/drift.dart';
import 'package:shareme/core/data/local/app_database.dart';
import 'package:shareme/core/data/local/schema/transfer_files_table.dart';
import 'package:shareme/core/data/local/schema/transfers_table.dart';

part 'history_dao.g.dart';

@DriftAccessor(tables: [Transfers, TransferFiles])
class HistoryDao extends DatabaseAccessor<AppDatabase> with _$HistoryDaoMixin {
  HistoryDao(super.db);

  /// Watch all transfer sessions ordered by most recent first.
  Stream<List<TransferRecord>> watchAllTransfers() {
    return (select(transfers)..orderBy([
      (t) => OrderingTerm(expression: t.timestampEpochMs, mode: OrderingMode.desc)
    ])).watch();
  }

  /// Get all files belonging to a specific transfer session id.
  Future<List<TransferFileRecord>> getFilesForTransfer(String transferId) {
    return (select(transferFiles)..where((f) => f.transferId.equals(transferId))).get();
  }

  /// Atomically insert a transfer session along with all of its associated files.
  Future<void> insertTransferSession(TransferRecord transfer, List<TransferFileRecord> files) {
    return transaction(() async {
      await into(transfers).insert(transfer, mode: InsertMode.insertOrReplace);
      await batch((b) {
        b.insertAll(transferFiles, files, mode: InsertMode.insertOrReplace);
      });
    });
  }

  /// Delete all transfer history records.
  Future<void> clearAllHistory() {
    return transaction(() async {
      await delete(transferFiles).go();
      await delete(transfers).go();
    });
  }
}
