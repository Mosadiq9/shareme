// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'peer_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PeerDeviceImpl _$$PeerDeviceImplFromJson(Map<String, dynamic> json) =>
    _$PeerDeviceImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      deviceModel: json['deviceModel'] as String,
      signalStrengthRssi: (json['signalStrengthRssi'] as num).toInt(),
      supportedBands: (json['supportedBands'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      is5GhzSupported: json['is5GhzSupported'] as bool? ?? false,
      p2pAddress: json['p2pAddress'] as String?,
    );

Map<String, dynamic> _$$PeerDeviceImplToJson(_$PeerDeviceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'deviceModel': instance.deviceModel,
      'signalStrengthRssi': instance.signalStrengthRssi,
      'supportedBands': instance.supportedBands,
      'is5GhzSupported': instance.is5GhzSupported,
      'p2pAddress': instance.p2pAddress,
    };
