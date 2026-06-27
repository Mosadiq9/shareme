/// ShareMe — Transfer item entity.
///
/// Represents an individual file within a transfer session.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_item.freezed.dart';
part 'transfer_item.g.dart';

enum TransferItemStatus { pending, transferring, completed, failed }

@freezed
class TransferItem with _$TransferItem {
  const factory TransferItem({
    required String id,
    required String name,
    required int sizeBytes,
    required String mimeType,
    @Default(0.0) double progress,
    @Default(TransferItemStatus.pending) TransferItemStatus status,
  }) = _TransferItem;

  factory TransferItem.fromJson(Map<String, dynamic> json) =>
      _$TransferItemFromJson(json);
}
