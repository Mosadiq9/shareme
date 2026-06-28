// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hotspot_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$HotspotState {
  HotspotStatus get status => throw _privateConstructorUsedError;
  String? get groupOwnerIp => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of HotspotState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HotspotStateCopyWith<HotspotState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HotspotStateCopyWith<$Res> {
  factory $HotspotStateCopyWith(
    HotspotState value,
    $Res Function(HotspotState) then,
  ) = _$HotspotStateCopyWithImpl<$Res, HotspotState>;
  @useResult
  $Res call({HotspotStatus status, String? groupOwnerIp, String? errorMessage});
}

/// @nodoc
class _$HotspotStateCopyWithImpl<$Res, $Val extends HotspotState>
    implements $HotspotStateCopyWith<$Res> {
  _$HotspotStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HotspotState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? groupOwnerIp = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as HotspotStatus,
            groupOwnerIp: freezed == groupOwnerIp
                ? _value.groupOwnerIp
                : groupOwnerIp // ignore: cast_nullable_to_non_nullable
                      as String?,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HotspotStateImplCopyWith<$Res>
    implements $HotspotStateCopyWith<$Res> {
  factory _$$HotspotStateImplCopyWith(
    _$HotspotStateImpl value,
    $Res Function(_$HotspotStateImpl) then,
  ) = __$$HotspotStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({HotspotStatus status, String? groupOwnerIp, String? errorMessage});
}

/// @nodoc
class __$$HotspotStateImplCopyWithImpl<$Res>
    extends _$HotspotStateCopyWithImpl<$Res, _$HotspotStateImpl>
    implements _$$HotspotStateImplCopyWith<$Res> {
  __$$HotspotStateImplCopyWithImpl(
    _$HotspotStateImpl _value,
    $Res Function(_$HotspotStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HotspotState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? groupOwnerIp = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$HotspotStateImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as HotspotStatus,
        groupOwnerIp: freezed == groupOwnerIp
            ? _value.groupOwnerIp
            : groupOwnerIp // ignore: cast_nullable_to_non_nullable
                  as String?,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$HotspotStateImpl implements _HotspotState {
  const _$HotspotStateImpl({
    this.status = HotspotStatus.idle,
    this.groupOwnerIp,
    this.errorMessage,
  });

  @override
  @JsonKey()
  final HotspotStatus status;
  @override
  final String? groupOwnerIp;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'HotspotState(status: $status, groupOwnerIp: $groupOwnerIp, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HotspotStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.groupOwnerIp, groupOwnerIp) ||
                other.groupOwnerIp == groupOwnerIp) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, status, groupOwnerIp, errorMessage);

  /// Create a copy of HotspotState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HotspotStateImplCopyWith<_$HotspotStateImpl> get copyWith =>
      __$$HotspotStateImplCopyWithImpl<_$HotspotStateImpl>(this, _$identity);
}

abstract class _HotspotState implements HotspotState {
  const factory _HotspotState({
    final HotspotStatus status,
    final String? groupOwnerIp,
    final String? errorMessage,
  }) = _$HotspotStateImpl;

  @override
  HotspotStatus get status;
  @override
  String? get groupOwnerIp;
  @override
  String? get errorMessage;

  /// Create a copy of HotspotState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HotspotStateImplCopyWith<_$HotspotStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
