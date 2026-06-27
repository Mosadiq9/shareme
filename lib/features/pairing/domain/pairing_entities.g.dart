// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pairing_entities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PairingRequestImpl _$$PairingRequestImplFromJson(Map<String, dynamic> json) =>
    _$PairingRequestImpl(
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      itemCount: (json['itemCount'] as num).toInt(),
      totalBytes: (json['totalBytes'] as num).toInt(),
      sessionToken: json['sessionToken'] as String,
      supportedBands: (json['supportedBands'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$PairingRequestImplToJson(
  _$PairingRequestImpl instance,
) => <String, dynamic>{
  'senderId': instance.senderId,
  'senderName': instance.senderName,
  'itemCount': instance.itemCount,
  'totalBytes': instance.totalBytes,
  'sessionToken': instance.sessionToken,
  'supportedBands': instance.supportedBands,
};

_$PairingResponseImpl _$$PairingResponseImplFromJson(
  Map<String, dynamic> json,
) => _$PairingResponseImpl(
  negotiatedBand: json['negotiatedBand'] as String,
  port: (json['port'] as num).toInt(),
  isVerified: json['isVerified'] as bool,
  sessionToken: json['sessionToken'] as String,
);

Map<String, dynamic> _$$PairingResponseImplToJson(
  _$PairingResponseImpl instance,
) => <String, dynamic>{
  'negotiatedBand': instance.negotiatedBand,
  'port': instance.port,
  'isVerified': instance.isVerified,
  'sessionToken': instance.sessionToken,
};
