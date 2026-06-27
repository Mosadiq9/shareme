/// ShareMe — Drift Schema: Transfer Files Table.
///
/// Backend Schema §2 (Schema A): Stores individual files associated with a transfer session.
library;

import 'package:drift/drift.dart';
import 'package:shareme/core/data/local/schema/transfers_table.dart';

@DataClassName('TransferFileRecord')
class TransferFiles extends Table {
  /// Unique UUID for the file item.
  TextColumn get id => text()();

  /// Foreign key referencing [Transfers.id].
  TextColumn get transferId => text().references(Transfers, #id, onDelete: KeyAction.cascade)();

  /// Original filename (e.g. "vacation_video.mp4").
  TextColumn get fileName => text()();

  /// File size in bytes.
  IntColumn get sizeBytes => integer()();

  /// MIME type (e.g. "video/mp4", "image/png").
  TextColumn get mimeType => text()();

  /// Local filesystem storage path where received file is saved or sent file originated.
  TextColumn get storagePath => text()();

  @override
  Set<Column> get primaryKey => {id};
}
