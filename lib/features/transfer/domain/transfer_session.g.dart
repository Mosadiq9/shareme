// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransferSessionImpl _$$TransferSessionImplFromJson(
  Map<String, dynamic> json,
) => _$TransferSessionImpl(
  sessionId: json['sessionId'] as String,
  peerDevice: PeerDevice.fromJson(json['peerDevice'] as Map<String, dynamic>),
  items: (json['items'] as List<dynamic>)
      .map((e) => TransferItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  status:
      $enumDecodeNullable(_$TransferSessionStatusEnumMap, json['status']) ??
      TransferSessionStatus.connecting,
  speedBytesPerSec: (json['speedBytesPerSec'] as num?)?.toDouble() ?? 0.0,
  totalBytes: (json['totalBytes'] as num?)?.toInt() ?? 0,
  transferredBytes: (json['transferredBytes'] as num?)?.toInt() ?? 0,
  elapsedSeconds: (json['elapsedSeconds'] as num?)?.toInt() ?? 0,
  etaSeconds: (json['etaSeconds'] as num?)?.toInt() ?? 0,
  errorMessage: json['errorMessage'] as String?,
);

Map<String, dynamic> _$$TransferSessionImplToJson(
  _$TransferSessionImpl instance,
) => <String, dynamic>{
  'sessionId': instance.sessionId,
  'peerDevice': instance.peerDevice,
  'items': instance.items,
  'status': _$TransferSessionStatusEnumMap[instance.status]!,
  'speedBytesPerSec': instance.speedBytesPerSec,
  'totalBytes': instance.totalBytes,
  'transferredBytes': instance.transferredBytes,
  'elapsedSeconds': instance.elapsedSeconds,
  'etaSeconds': instance.etaSeconds,
  'errorMessage': instance.errorMessage,
};

const _$TransferSessionStatusEnumMap = {
  TransferSessionStatus.connecting: 'connecting',
  TransferSessionStatus.negotiating: 'negotiating',
  TransferSessionStatus.transferring: 'transferring',
  TransferSessionStatus.completed: 'completed',
  TransferSessionStatus.failed: 'failed',
};
