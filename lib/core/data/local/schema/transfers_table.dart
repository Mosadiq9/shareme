/// ShareMe — Drift Schema: Transfers Table.
///
/// Backend Schema §2 (Schema A): Stores historical transfer sessions.
library;

import 'package:drift/drift.dart';

@DataClassName('TransferRecord')
class Transfers extends Table {
  /// Unique UUID for the transfer session.
  TextColumn get id => text()();

  /// Name of the peer device (e.g. "Galaxy S24 Ultra").
  TextColumn get peerName => text()();

  /// Total size of all files in this transfer session in bytes.
  IntColumn get totalBytes => integer()();

  /// Number of files included in this session.
  IntColumn get fileCount => integer()();

  /// Unix epoch timestamp in milliseconds when the session occurred.
  IntColumn get timestampEpochMs => integer()();

  /// True if we sent files, false if we received them.
  BoolColumn get isSent => boolean()();

  /// Session final status: 'completed', 'failed', or 'canceled'.
  TextColumn get status => text()();

  /// Duration of the transfer in seconds.
  IntColumn get durationSeconds => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
