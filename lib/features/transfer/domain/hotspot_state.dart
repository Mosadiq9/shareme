library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'hotspot_state.freezed.dart';

enum HotspotStatus {
  idle,
  creating,
  connecting,
  connected,
  failed,
}

@freezed
class HotspotState with _$HotspotState {
  const factory HotspotState({
    @Default(HotspotStatus.idle) HotspotStatus status,
    String? groupOwnerIp,
    String? errorMessage,
  }) = _HotspotState;
}
