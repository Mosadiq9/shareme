/// ShareMe — Transfer history item entity.
///
/// Represents a completed or failed transfer shown on the Home screen.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'history_item.freezed.dart';
part 'history_item.g.dart';

@freezed
class HistoryItem with _$HistoryItem {
  const factory HistoryItem({
    required String id,
    required String peerName,
    required int fileCount,
    required int totalSizeBytes,
    required int timestampEpochMs,
    required bool isSent,
    required bool isSuccess,
  }) = _HistoryItem;

  factory HistoryItem.fromJson(Map<String, dynamic> json) =>
      _$HistoryItemFromJson(json);
}
