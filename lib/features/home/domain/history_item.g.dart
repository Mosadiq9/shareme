// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HistoryItemImpl _$$HistoryItemImplFromJson(Map<String, dynamic> json) =>
    _$HistoryItemImpl(
      id: json['id'] as String,
      peerName: json['peerName'] as String,
      fileCount: (json['fileCount'] as num).toInt(),
      totalSizeBytes: (json['totalSizeBytes'] as num).toInt(),
      timestampEpochMs: (json['timestampEpochMs'] as num).toInt(),
      isSent: json['isSent'] as bool,
      isSuccess: json['isSuccess'] as bool,
    );

Map<String, dynamic> _$$HistoryItemImplToJson(_$HistoryItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'peerName': instance.peerName,
      'fileCount': instance.fileCount,
      'totalSizeBytes': instance.totalSizeBytes,
      'timestampEpochMs': instance.timestampEpochMs,
      'isSent': instance.isSent,
      'isSuccess': instance.isSuccess,
    };
