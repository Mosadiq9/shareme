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
          await settingsDao.saveSetting('device_name', 'ShareMe Mobile');
        },
        beforeOpen: (details) async {
          await (delete(transfers)..where((t) => t.id.isIn(['seed_1', 'seed_2']))).go();
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
