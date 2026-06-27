/// ShareMe — Transfer session entity.
///
/// Represents an active or historical batch transfer session between two peers.
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shareme/features/discovery/domain/peer_device.dart';
import 'transfer_item.dart';

part 'transfer_session.freezed.dart';
part 'transfer_session.g.dart';

enum TransferSessionStatus {
  connecting,
  negotiating,
  transferring,
  completed,
  failed,
}

@freezed
class TransferSession with _$TransferSession {
  const factory TransferSession({
    required String sessionId,
    required PeerDevice peerDevice,
    required List<TransferItem> items,
    @Default(TransferSessionStatus.connecting) TransferSessionStatus status,
    @Default(0.0) double speedBytesPerSec,
    @Default(0) int totalBytes,
    @Default(0) int transferredBytes,
    @Default(0) int elapsedSeconds,
    @Default(0) int etaSeconds,
    String? errorMessage,
  }) = _TransferSession;

  factory TransferSession.fromJson(Map<String, dynamic> json) =>
      _$TransferSessionFromJson(json);
}
