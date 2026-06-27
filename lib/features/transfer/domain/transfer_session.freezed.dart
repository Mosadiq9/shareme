// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TransferSession _$TransferSessionFromJson(Map<String, dynamic> json) {
  return _TransferSession.fromJson(json);
}

/// @nodoc
mixin _$TransferSession {
  String get sessionId => throw _privateConstructorUsedError;
  PeerDevice get peerDevice => throw _privateConstructorUsedError;
  List<TransferItem> get items => throw _privateConstructorUsedError;
  bool get isSent => throw _privateConstructorUsedError;
  TransferSessionStatus get status => throw _privateConstructorUsedError;
  double get speedBytesPerSec => throw _privateConstructorUsedError;
  int get totalBytes => throw _privateConstructorUsedError;
  int get transferredBytes => throw _privateConstructorUsedError;
  int get elapsedSeconds => throw _privateConstructorUsedError;
  int get etaSeconds => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Serializes this TransferSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransferSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransferSessionCopyWith<TransferSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferSessionCopyWith<$Res> {
  factory $TransferSessionCopyWith(
    TransferSession value,
    $Res Function(TransferSession) then,
  ) = _$TransferSessionCopyWithImpl<$Res, TransferSession>;
  @useResult
  $Res call({
    String sessionId,
    PeerDevice peerDevice,
    List<TransferItem> items,
    bool isSent,
    TransferSessionStatus status,
    double speedBytesPerSec,
    int totalBytes,
    int transferredBytes,
    int elapsedSeconds,
    int etaSeconds,
    String? errorMessage,
  });

  $PeerDeviceCopyWith<$Res> get peerDevice;
}

/// @nodoc
class _$TransferSessionCopyWithImpl<$Res, $Val extends TransferSession>
    implements $TransferSessionCopyWith<$Res> {
  _$TransferSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransferSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? peerDevice = null,
    Object? items = null,
    Object? isSent = null,
    Object? status = null,
    Object? speedBytesPerSec = null,
    Object? totalBytes = null,
    Object? transferredBytes = null,
    Object? elapsedSeconds = null,
    Object? etaSeconds = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            sessionId: null == sessionId
                ? _value.sessionId
                : sessionId // ignore: cast_nullable_to_non_nullable
                      as String,
            peerDevice: null == peerDevice
                ? _value.peerDevice
                : peerDevice // ignore: cast_nullable_to_non_nullable
                      as PeerDevice,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<TransferItem>,
            isSent: null == isSent
                ? _value.isSent
                : isSent // ignore: cast_nullable_to_non_nullable
                      as bool,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as TransferSessionStatus,
            speedBytesPerSec: null == speedBytesPerSec
                ? _value.speedBytesPerSec
                : speedBytesPerSec // ignore: cast_nullable_to_non_nullable
                      as double,
            totalBytes: null == totalBytes
                ? _value.totalBytes
                : totalBytes // ignore: cast_nullable_to_non_nullable
                      as int,
            transferredBytes: null == transferredBytes
                ? _value.transferredBytes
                : transferredBytes // ignore: cast_nullable_to_non_nullable
                      as int,
            elapsedSeconds: null == elapsedSeconds
                ? _value.elapsedSeconds
                : elapsedSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            etaSeconds: null == etaSeconds
                ? _value.etaSeconds
                : etaSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of TransferSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PeerDeviceCopyWith<$Res> get peerDevice {
    return $PeerDeviceCopyWith<$Res>(_value.peerDevice, (value) {
      return _then(_value.copyWith(peerDevice: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TransferSessionImplCopyWith<$Res>
    implements $TransferSessionCopyWith<$Res> {
  factory _$$TransferSessionImplCopyWith(
    _$TransferSessionImpl value,
    $Res Function(_$TransferSessionImpl) then,
  ) = __$$TransferSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String sessionId,
    PeerDevice peerDevice,
    List<TransferItem> items,
    bool isSent,
    TransferSessionStatus status,
    double speedBytesPerSec,
    int totalBytes,
    int transferredBytes,
    int elapsedSeconds,
    int etaSeconds,
    String? errorMessage,
  });

  @override
  $PeerDeviceCopyWith<$Res> get peerDevice;
}

/// @nodoc
class __$$TransferSessionImplCopyWithImpl<$Res>
    extends _$TransferSessionCopyWithImpl<$Res, _$TransferSessionImpl>
    implements _$$TransferSessionImplCopyWith<$Res> {
  __$$TransferSessionImplCopyWithImpl(
    _$TransferSessionImpl _value,
    $Res Function(_$TransferSessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransferSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? peerDevice = null,
    Object? items = null,
    Object? isSent = null,
    Object? status = null,
    Object? speedBytesPerSec = null,
    Object? totalBytes = null,
    Object? transferredBytes = null,
    Object? elapsedSeconds = null,
    Object? etaSeconds = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$TransferSessionImpl(
        sessionId: null == sessionId
            ? _value.sessionId
            : sessionId // ignore: cast_nullable_to_non_nullable
                  as String,
        peerDevice: null == peerDevice
            ? _value.peerDevice
            : peerDevice // ignore: cast_nullable_to_non_nullable
                  as PeerDevice,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<TransferItem>,
        isSent: null == isSent
            ? _value.isSent
            : isSent // ignore: cast_nullable_to_non_nullable
                  as bool,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as TransferSessionStatus,
        speedBytesPerSec: null == speedBytesPerSec
            ? _value.speedBytesPerSec
            : speedBytesPerSec // ignore: cast_nullable_to_non_nullable
                  as double,
        totalBytes: null == totalBytes
            ? _value.totalBytes
            : totalBytes // ignore: cast_nullable_to_non_nullable
                  as int,
        transferredBytes: null == transferredBytes
            ? _value.transferredBytes
            : transferredBytes // ignore: cast_nullable_to_non_nullable
                  as int,
        elapsedSeconds: null == elapsedSeconds
            ? _value.elapsedSeconds
            : elapsedSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        etaSeconds: null == etaSeconds
            ? _value.etaSeconds
            : etaSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TransferSessionImpl implements _TransferSession {
  const _$TransferSessionImpl({
    required this.sessionId,
    required this.peerDevice,
    required final List<TransferItem> items,
    this.isSent = true,
    this.status = TransferSessionStatus.connecting,
    this.speedBytesPerSec = 0.0,
    this.totalBytes = 0,
    this.transferredBytes = 0,
    this.elapsedSeconds = 0,
    this.etaSeconds = 0,
    this.errorMessage,
  }) : _items = items;

  factory _$TransferSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransferSessionImplFromJson(json);

  @override
  final String sessionId;
  @override
  final PeerDevice peerDevice;
  final List<TransferItem> _items;
  @override
  List<TransferItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey()
  final bool isSent;
  @override
  @JsonKey()
  final TransferSessionStatus status;
  @override
  @JsonKey()
  final double speedBytesPerSec;
  @override
  @JsonKey()
  final int totalBytes;
  @override
  @JsonKey()
  final int transferredBytes;
  @override
  @JsonKey()
  final int elapsedSeconds;
  @override
  @JsonKey()
  final int etaSeconds;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'TransferSession(sessionId: $sessionId, peerDevice: $peerDevice, items: $items, isSent: $isSent, status: $status, speedBytesPerSec: $speedBytesPerSec, totalBytes: $totalBytes, transferredBytes: $transferredBytes, elapsedSeconds: $elapsedSeconds, etaSeconds: $etaSeconds, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferSessionImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.peerDevice, peerDevice) ||
                other.peerDevice == peerDevice) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.isSent, isSent) || other.isSent == isSent) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.speedBytesPerSec, speedBytesPerSec) ||
                other.speedBytesPerSec == speedBytesPerSec) &&
            (identical(other.totalBytes, totalBytes) ||
                other.totalBytes == totalBytes) &&
            (identical(other.transferredBytes, transferredBytes) ||
                other.transferredBytes == transferredBytes) &&
            (identical(other.elapsedSeconds, elapsedSeconds) ||
                other.elapsedSeconds == elapsedSeconds) &&
            (identical(other.etaSeconds, etaSeconds) ||
                other.etaSeconds == etaSeconds) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    sessionId,
    peerDevice,
    const DeepCollectionEquality().hash(_items),
    isSent,
    status,
    speedBytesPerSec,
    totalBytes,
    transferredBytes,
    elapsedSeconds,
    etaSeconds,
    errorMessage,
  );

  /// Create a copy of TransferSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferSessionImplCopyWith<_$TransferSessionImpl> get copyWith =>
      __$$TransferSessionImplCopyWithImpl<_$TransferSessionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TransferSessionImplToJson(this);
  }
}

abstract class _TransferSession implements TransferSession {
  const factory _TransferSession({
    required final String sessionId,
    required final PeerDevice peerDevice,
    required final List<TransferItem> items,
    final bool isSent,
    final TransferSessionStatus status,
    final double speedBytesPerSec,
    final int totalBytes,
    final int transferredBytes,
    final int elapsedSeconds,
    final int etaSeconds,
    final String? errorMessage,
  }) = _$TransferSessionImpl;

  factory _TransferSession.fromJson(Map<String, dynamic> json) =
      _$TransferSessionImpl.fromJson;

  @override
  String get sessionId;
  @override
  PeerDevice get peerDevice;
  @override
  List<TransferItem> get items;
  @override
  bool get isSent;
  @override
  TransferSessionStatus get status;
  @override
  double get speedBytesPerSec;
  @override
  int get totalBytes;
  @override
  int get transferredBytes;
  @override
  int get elapsedSeconds;
  @override
  int get etaSeconds;
  @override
  String? get errorMessage;

  /// Create a copy of TransferSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransferSessionImplCopyWith<_$TransferSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
