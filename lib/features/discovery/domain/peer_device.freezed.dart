// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'peer_device.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PeerDevice _$PeerDeviceFromJson(Map<String, dynamic> json) {
  return _PeerDevice.fromJson(json);
}

/// @nodoc
mixin _$PeerDevice {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get deviceModel => throw _privateConstructorUsedError;
  int get signalStrengthRssi => throw _privateConstructorUsedError;
  List<String> get supportedBands => throw _privateConstructorUsedError;
  bool get is5GhzSupported => throw _privateConstructorUsedError;
  String? get p2pAddress => throw _privateConstructorUsedError;

  /// Serializes this PeerDevice to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PeerDevice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PeerDeviceCopyWith<PeerDevice> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PeerDeviceCopyWith<$Res> {
  factory $PeerDeviceCopyWith(
    PeerDevice value,
    $Res Function(PeerDevice) then,
  ) = _$PeerDeviceCopyWithImpl<$Res, PeerDevice>;
  @useResult
  $Res call({
    String id,
    String name,
    String deviceModel,
    int signalStrengthRssi,
    List<String> supportedBands,
    bool is5GhzSupported,
    String? p2pAddress,
  });
}

/// @nodoc
class _$PeerDeviceCopyWithImpl<$Res, $Val extends PeerDevice>
    implements $PeerDeviceCopyWith<$Res> {
  _$PeerDeviceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PeerDevice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? deviceModel = null,
    Object? signalStrengthRssi = null,
    Object? supportedBands = null,
    Object? is5GhzSupported = null,
    Object? p2pAddress = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            deviceModel: null == deviceModel
                ? _value.deviceModel
                : deviceModel // ignore: cast_nullable_to_non_nullable
                      as String,
            signalStrengthRssi: null == signalStrengthRssi
                ? _value.signalStrengthRssi
                : signalStrengthRssi // ignore: cast_nullable_to_non_nullable
                      as int,
            supportedBands: null == supportedBands
                ? _value.supportedBands
                : supportedBands // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            is5GhzSupported: null == is5GhzSupported
                ? _value.is5GhzSupported
                : is5GhzSupported // ignore: cast_nullable_to_non_nullable
                      as bool,
            p2pAddress: freezed == p2pAddress
                ? _value.p2pAddress
                : p2pAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PeerDeviceImplCopyWith<$Res>
    implements $PeerDeviceCopyWith<$Res> {
  factory _$$PeerDeviceImplCopyWith(
    _$PeerDeviceImpl value,
    $Res Function(_$PeerDeviceImpl) then,
  ) = __$$PeerDeviceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String deviceModel,
    int signalStrengthRssi,
    List<String> supportedBands,
    bool is5GhzSupported,
    String? p2pAddress,
  });
}

/// @nodoc
class __$$PeerDeviceImplCopyWithImpl<$Res>
    extends _$PeerDeviceCopyWithImpl<$Res, _$PeerDeviceImpl>
    implements _$$PeerDeviceImplCopyWith<$Res> {
  __$$PeerDeviceImplCopyWithImpl(
    _$PeerDeviceImpl _value,
    $Res Function(_$PeerDeviceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PeerDevice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? deviceModel = null,
    Object? signalStrengthRssi = null,
    Object? supportedBands = null,
    Object? is5GhzSupported = null,
    Object? p2pAddress = freezed,
  }) {
    return _then(
      _$PeerDeviceImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        deviceModel: null == deviceModel
            ? _value.deviceModel
            : deviceModel // ignore: cast_nullable_to_non_nullable
                  as String,
        signalStrengthRssi: null == signalStrengthRssi
            ? _value.signalStrengthRssi
            : signalStrengthRssi // ignore: cast_nullable_to_non_nullable
                  as int,
        supportedBands: null == supportedBands
            ? _value._supportedBands
            : supportedBands // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        is5GhzSupported: null == is5GhzSupported
            ? _value.is5GhzSupported
            : is5GhzSupported // ignore: cast_nullable_to_non_nullable
                  as bool,
        p2pAddress: freezed == p2pAddress
            ? _value.p2pAddress
            : p2pAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PeerDeviceImpl implements _PeerDevice {
  const _$PeerDeviceImpl({
    required this.id,
    required this.name,
    required this.deviceModel,
    required this.signalStrengthRssi,
    required final List<String> supportedBands,
    this.is5GhzSupported = false,
    this.p2pAddress,
  }) : _supportedBands = supportedBands;

  factory _$PeerDeviceImpl.fromJson(Map<String, dynamic> json) =>
      _$$PeerDeviceImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String deviceModel;
  @override
  final int signalStrengthRssi;
  final List<String> _supportedBands;
  @override
  List<String> get supportedBands {
    if (_supportedBands is EqualUnmodifiableListView) return _supportedBands;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_supportedBands);
  }

  @override
  @JsonKey()
  final bool is5GhzSupported;
  @override
  final String? p2pAddress;

  @override
  String toString() {
    return 'PeerDevice(id: $id, name: $name, deviceModel: $deviceModel, signalStrengthRssi: $signalStrengthRssi, supportedBands: $supportedBands, is5GhzSupported: $is5GhzSupported, p2pAddress: $p2pAddress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PeerDeviceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.deviceModel, deviceModel) ||
                other.deviceModel == deviceModel) &&
            (identical(other.signalStrengthRssi, signalStrengthRssi) ||
                other.signalStrengthRssi == signalStrengthRssi) &&
            const DeepCollectionEquality().equals(
              other._supportedBands,
              _supportedBands,
            ) &&
            (identical(other.is5GhzSupported, is5GhzSupported) ||
                other.is5GhzSupported == is5GhzSupported) &&
            (identical(other.p2pAddress, p2pAddress) ||
                other.p2pAddress == p2pAddress));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    deviceModel,
    signalStrengthRssi,
    const DeepCollectionEquality().hash(_supportedBands),
    is5GhzSupported,
    p2pAddress,
  );

  /// Create a copy of PeerDevice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PeerDeviceImplCopyWith<_$PeerDeviceImpl> get copyWith =>
      __$$PeerDeviceImplCopyWithImpl<_$PeerDeviceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PeerDeviceImplToJson(this);
  }
}

abstract class _PeerDevice implements PeerDevice {
  const factory _PeerDevice({
    required final String id,
    required final String name,
    required final String deviceModel,
    required final int signalStrengthRssi,
    required final List<String> supportedBands,
    final bool is5GhzSupported,
    final String? p2pAddress,
  }) = _$PeerDeviceImpl;

  factory _PeerDevice.fromJson(Map<String, dynamic> json) =
      _$PeerDeviceImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get deviceModel;
  @override
  int get signalStrengthRssi;
  @override
  List<String> get supportedBands;
  @override
  bool get is5GhzSupported;
  @override
  String? get p2pAddress;

  /// Create a copy of PeerDevice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PeerDeviceImplCopyWith<_$PeerDeviceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
