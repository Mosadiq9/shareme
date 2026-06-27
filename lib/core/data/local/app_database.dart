/// ShareMe — Local SQLite App Database.
///
/// Built with Drift for reactive, type-safe persistence across isolates.
library;

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shareme/core/data/local/daos/history_dao.dart';
import 'package:shareme/core/data/local/daos/settings_dao.dart';
import 'package:shareme/core/data/local/schema/settings_table.dart';
import 'package:shareme/core/data/local/schema/transfer_files_table.dart';
import 'package:shareme/core/data/local/schema/transfers_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Transfers, TransferFiles, Settings],
  daos: [HistoryDao, SettingsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Constructor for in-memory unit testing.
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await settingsDao.saveSetting('device_name', 'Pixel 8 Pro (Mosadik)');

          final now = DateTime.now().millisecondsSinceEpoch;
          await historyDao.insertTransferSession(
            TransferRecord(
              id: 'seed_1',
              peerName: 'iPhone 15 Pro',
              totalBytes: 342 * 1024 * 1024,
              fileCount: 12,
              timestampEpochMs: now - (15 * 60 * 1000),
              isSent: true,
              status: 'completed',
              durationSeconds: 8,
            ),
            [],
          );
          await historyDao.insertTransferSession(
            TransferRecord(
              id: 'seed_2',
              peerName: 'Galaxy S24 Ultra',
              totalBytes: 1850 * 1024 * 1024,
              fileCount: 1,
              timestampEpochMs: now - (3 * 3600 * 1000),
              isSent: false,
              status: 'completed',
              durationSeconds: 41,
            ),
            [],
          );
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'shareme.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
