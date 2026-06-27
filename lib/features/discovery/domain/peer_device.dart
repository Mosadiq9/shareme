/// ShareMe — Peer device entity.
///
/// Represents a peer discovered via WiFi Direct or mDNS radar sweep.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'peer_device.freezed.dart';
part 'peer_device.g.dart';

@freezed
class PeerDevice with _$PeerDevice {
  const factory PeerDevice({
    required String id,
    required String name,
    required String deviceModel,
    required int signalStrengthRssi,
    required List<String> supportedBands,
    @Default(false) bool is5GhzSupported,
  }) = _PeerDevice;

  factory PeerDevice.fromJson(Map<String, dynamic> json) =>
      _$PeerDeviceFromJson(json);
}
