/// ShareMe — Drift DAO: Settings Accessor.
///
/// Handles key-value configuration reading and writing.
library;

import 'package:drift/drift.dart';
import 'package:shareme/core/data/local/app_database.dart';
import 'package:shareme/core/data/local/schema/settings_table.dart';

part 'settings_dao.g.dart';

@DriftAccessor(tables: [Settings])
class SettingsDao extends DatabaseAccessor<AppDatabase> with _$SettingsDaoMixin {
  SettingsDao(super.db);

  /// Watch a specific setting value by key.
  Stream<String?> watchSetting(String key) {
    return (select(settings)..where((s) => s.key.equals(key)))
        .map((s) => s.value)
        .watchSingleOrNull();
  }

  /// Get a specific setting value by key once.
  Future<String?> getSetting(String key) async {
    final record = await (select(settings)..where((s) => s.key.equals(key))).getSingleOrNull();
    return record?.value;
  }

  /// Insert or update a setting key-value pair.
  Future<void> saveSetting(String key, String value) {
    return into(settings).insert(
      SettingRecord(key: key, value: value),
      mode: InsertMode.insertOrReplace,
    );
  }
}
