// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransferItemImpl _$$TransferItemImplFromJson(Map<String, dynamic> json) =>
    _$TransferItemImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      sizeBytes: (json['sizeBytes'] as num).toInt(),
      mimeType: json['mimeType'] as String,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      status:
          $enumDecodeNullable(_$TransferItemStatusEnumMap, json['status']) ??
          TransferItemStatus.pending,
    );

Map<String, dynamic> _$$TransferItemImplToJson(_$TransferItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sizeBytes': instance.sizeBytes,
      'mimeType': instance.mimeType,
      'progress': instance.progress,
      'status': _$TransferItemStatusEnumMap[instance.status]!,
    };

const _$TransferItemStatusEnumMap = {
  TransferItemStatus.pending: 'pending',
  TransferItemStatus.transferring: 'transferring',
  TransferItemStatus.completed: 'completed',
  TransferItemStatus.failed: 'failed',
};
