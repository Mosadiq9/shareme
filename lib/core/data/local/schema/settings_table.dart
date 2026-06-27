/// ShareMe — Drift Schema: Settings Table.
///
/// Backend Schema §2 (Schema A): Stores persisted key-value app configurations
/// (e.g. customized device display name, default download folder).
library;

import 'package:drift/drift.dart';

@DataClassName('SettingRecord')
class Settings extends Table {
  /// Setting key (e.g. "device_name").
  TextColumn get key => text()();

  /// Setting value (e.g. "ShareMe Galaxy S24").
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
