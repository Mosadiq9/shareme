// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pairing_entities.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PairingRequest _$PairingRequestFromJson(Map<String, dynamic> json) {
  return _PairingRequest.fromJson(json);
}

/// @nodoc
mixin _$PairingRequest {
  String get senderId => throw _privateConstructorUsedError;
  String get senderName => throw _privateConstructorUsedError;
  int get itemCount => throw _privateConstructorUsedError;
  int get totalBytes => throw _privateConstructorUsedError;
  String get sessionToken => throw _privateConstructorUsedError;
  List<String> get supportedBands => throw _privateConstructorUsedError;

  /// Serializes this PairingRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PairingRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PairingRequestCopyWith<PairingRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PairingRequestCopyWith<$Res> {
  factory $PairingRequestCopyWith(
    PairingRequest value,
    $Res Function(PairingRequest) then,
  ) = _$PairingRequestCopyWithImpl<$Res, PairingRequest>;
  @useResult
  $Res call({
    String senderId,
    String senderName,
    int itemCount,
    int totalBytes,
    String sessionToken,
    List<String> supportedBands,
  });
}

/// @nodoc
class _$PairingRequestCopyWithImpl<$Res, $Val extends PairingRequest>
    implements $PairingRequestCopyWith<$Res> {
  _$PairingRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PairingRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? senderId = null,
    Object? senderName = null,
    Object? itemCount = null,
    Object? totalBytes = null,
    Object? sessionToken = null,
    Object? supportedBands = null,
  }) {
    return _then(
      _value.copyWith(
            senderId: null == senderId
                ? _value.senderId
                : senderId // ignore: cast_nullable_to_non_nullable
                      as String,
            senderName: null == senderName
                ? _value.senderName
                : senderName // ignore: cast_nullable_to_non_nullable
                      as String,
            itemCount: null == itemCount
                ? _value.itemCount
                : itemCount // ignore: cast_nullable_to_non_nullable
                      as int,
            totalBytes: null == totalBytes
                ? _value.totalBytes
                : totalBytes // ignore: cast_nullable_to_non_nullable
                      as int,
            sessionToken: null == sessionToken
                ? _value.sessionToken
                : sessionToken // ignore: cast_nullable_to_non_nullable
                      as String,
            supportedBands: null == supportedBands
                ? _value.supportedBands
                : supportedBands // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PairingRequestImplCopyWith<$Res>
    implements $PairingRequestCopyWith<$Res> {
  factory _$$PairingRequestImplCopyWith(
    _$PairingRequestImpl value,
    $Res Function(_$PairingRequestImpl) then,
  ) = __$$PairingRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String senderId,
    String senderName,
    int itemCount,
    int totalBytes,
    String sessionToken,
    List<String> supportedBands,
  });
}

/// @nodoc
class __$$PairingRequestImplCopyWithImpl<$Res>
    extends _$PairingRequestCopyWithImpl<$Res, _$PairingRequestImpl>
    implements _$$PairingRequestImplCopyWith<$Res> {
  __$$PairingRequestImplCopyWithImpl(
    _$PairingRequestImpl _value,
    $Res Function(_$PairingRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PairingRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? senderId = null,
    Object? senderName = null,
    Object? itemCount = null,
    Object? totalBytes = null,
    Object? sessionToken = null,
    Object? supportedBands = null,
  }) {
    return _then(
      _$PairingRequestImpl(
        senderId: null == senderId
            ? _value.senderId
            : senderId // ignore: cast_nullable_to_non_nullable
                  as String,
        senderName: null == senderName
            ? _value.senderName
            : senderName // ignore: cast_nullable_to_non_nullable
                  as String,
        itemCount: null == itemCount
            ? _value.itemCount
            : itemCount // ignore: cast_nullable_to_non_nullable
                  as int,
        totalBytes: null == totalBytes
            ? _value.totalBytes
            : totalBytes // ignore: cast_nullable_to_non_nullable
                  as int,
        sessionToken: null == sessionToken
            ? _value.sessionToken
            : sessionToken // ignore: cast_nullable_to_non_nullable
                  as String,
        supportedBands: null == supportedBands
            ? _value._supportedBands
            : supportedBands // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PairingRequestImpl implements _PairingRequest {
  const _$PairingRequestImpl({
    required this.senderId,
    required this.senderName,
    required this.itemCount,
    required this.totalBytes,
    required this.sessionToken,
    required final List<String> supportedBands,
  }) : _supportedBands = supportedBands;

  factory _$PairingRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$PairingRequestImplFromJson(json);

  @override
  final String senderId;
  @override
  final String senderName;
  @override
  final int itemCount;
  @override
  final int totalBytes;
  @override
  final String sessionToken;
  final List<String> _supportedBands;
  @override
  List<String> get supportedBands {
    if (_supportedBands is EqualUnmodifiableListView) return _supportedBands;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_supportedBands);
  }

  @override
  String toString() {
    return 'PairingRequest(senderId: $senderId, senderName: $senderName, itemCount: $itemCount, totalBytes: $totalBytes, sessionToken: $sessionToken, supportedBands: $supportedBands)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PairingRequestImpl &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.senderName, senderName) ||
                other.senderName == senderName) &&
            (identical(other.itemCount, itemCount) ||
                other.itemCount == itemCount) &&
            (identical(other.totalBytes, totalBytes) ||
                other.totalBytes == totalBytes) &&
            (identical(other.sessionToken, sessionToken) ||
                other.sessionToken == sessionToken) &&
            const DeepCollectionEquality().equals(
              other._supportedBands,
              _supportedBands,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    senderId,
    senderName,
    itemCount,
    totalBytes,
    sessionToken,
    const DeepCollectionEquality().hash(_supportedBands),
  );

  /// Create a copy of PairingRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PairingRequestImplCopyWith<_$PairingRequestImpl> get copyWith =>
      __$$PairingRequestImplCopyWithImpl<_$PairingRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PairingRequestImplToJson(this);
  }
}

abstract class _PairingRequest implements PairingRequest {
  const factory _PairingRequest({
    required final String senderId,
    required final String senderName,
    required final int itemCount,
    required final int totalBytes,
    required final String sessionToken,
    required final List<String> supportedBands,
  }) = _$PairingRequestImpl;

  factory _PairingRequest.fromJson(Map<String, dynamic> json) =
      _$PairingRequestImpl.fromJson;

  @override
  String get senderId;
  @override
  String get senderName;
  @override
  int get itemCount;
  @override
  int get totalBytes;
  @override
  String get sessionToken;
  @override
  List<String> get supportedBands;

  /// Create a copy of PairingRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PairingRequestImplCopyWith<_$PairingRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PairingResponse _$PairingResponseFromJson(Map<String, dynamic> json) {
  return _PairingResponse.fromJson(json);
}

/// @nodoc
mixin _$PairingResponse {
  String get negotiatedBand => throw _privateConstructorUsedError;
  int get port => throw _privateConstructorUsedError;
  bool get isVerified => throw _privateConstructorUsedError;
  String get sessionToken => throw _privateConstructorUsedError;

  /// Serializes this PairingResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PairingResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PairingResponseCopyWith<PairingResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PairingResponseCopyWith<$Res> {
  factory $PairingResponseCopyWith(
    PairingResponse value,
    $Res Function(PairingResponse) then,
  ) = _$PairingResponseCopyWithImpl<$Res, PairingResponse>;
  @useResult
  $Res call({
    String negotiatedBand,
    int port,
    bool isVerified,
    String sessionToken,
  });
}

/// @nodoc
class _$PairingResponseCopyWithImpl<$Res, $Val extends PairingResponse>
    implements $PairingResponseCopyWith<$Res> {
  _$PairingResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PairingResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? negotiatedBand = null,
    Object? port = null,
    Object? isVerified = null,
    Object? sessionToken = null,
  }) {
    return _then(
      _value.copyWith(
            negotiatedBand: null == negotiatedBand
                ? _value.negotiatedBand
                : negotiatedBand // ignore: cast_nullable_to_non_nullable
                      as String,
            port: null == port
                ? _value.port
                : port // ignore: cast_nullable_to_non_nullable
                      as int,
            isVerified: null == isVerified
                ? _value.isVerified
                : isVerified // ignore: cast_nullable_to_non_nullable
                      as bool,
            sessionToken: null == sessionToken
                ? _value.sessionToken
                : sessionToken // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PairingResponseImplCopyWith<$Res>
    implements $PairingResponseCopyWith<$Res> {
  factory _$$PairingResponseImplCopyWith(
    _$PairingResponseImpl value,
    $Res Function(_$PairingResponseImpl) then,
  ) = __$$PairingResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String negotiatedBand,
    int port,
    bool isVerified,
    String sessionToken,
  });
}

/// @nodoc
class __$$PairingResponseImplCopyWithImpl<$Res>
    extends _$PairingResponseCopyWithImpl<$Res, _$PairingResponseImpl>
    implements _$$PairingResponseImplCopyWith<$Res> {
  __$$PairingResponseImplCopyWithImpl(
    _$PairingResponseImpl _value,
    $Res Function(_$PairingResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PairingResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? negotiatedBand = null,
    Object? port = null,
    Object? isVerified = null,
    Object? sessionToken = null,
  }) {
    return _then(
      _$PairingResponseImpl(
        negotiatedBand: null == negotiatedBand
            ? _value.negotiatedBand
            : negotiatedBand // ignore: cast_nullable_to_non_nullable
                  as String,
        port: null == port
            ? _value.port
            : port // ignore: cast_nullable_to_non_nullable
                  as int,
        isVerified: null == isVerified
            ? _value.isVerified
            : isVerified // ignore: cast_nullable_to_non_nullable
                  as bool,
        sessionToken: null == sessionToken
            ? _value.sessionToken
            : sessionToken // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PairingResponseImpl implements _PairingResponse {
  const _$PairingResponseImpl({
    required this.negotiatedBand,
    required this.port,
    required this.isVerified,
    required this.sessionToken,
  });

  factory _$PairingResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PairingResponseImplFromJson(json);

  @override
  final String negotiatedBand;
  @override
  final int port;
  @override
  final bool isVerified;
  @override
  final String sessionToken;

  @override
  String toString() {
    return 'PairingResponse(negotiatedBand: $negotiatedBand, port: $port, isVerified: $isVerified, sessionToken: $sessionToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PairingResponseImpl &&
            (identical(other.negotiatedBand, negotiatedBand) ||
                other.negotiatedBand == negotiatedBand) &&
            (identical(other.port, port) || other.port == port) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.sessionToken, sessionToken) ||
                other.sessionToken == sessionToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, negotiatedBand, port, isVerified, sessionToken);

  /// Create a copy of PairingResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PairingResponseImplCopyWith<_$PairingResponseImpl> get copyWith =>
      __$$PairingResponseImplCopyWithImpl<_$PairingResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PairingResponseImplToJson(this);
  }
}

abstract class _PairingResponse implements PairingResponse {
  const factory _PairingResponse({
    required final String negotiatedBand,
    required final int port,
    required final bool isVerified,
    required final String sessionToken,
  }) = _$PairingResponseImpl;

  factory _PairingResponse.fromJson(Map<String, dynamic> json) =
      _$PairingResponseImpl.fromJson;

  @override
  String get negotiatedBand;
  @override
  int get port;
  @override
  bool get isVerified;
  @override
  String get sessionToken;

  /// Create a copy of PairingResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PairingResponseImplCopyWith<_$PairingResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
