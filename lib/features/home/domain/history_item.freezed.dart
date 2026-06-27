// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

HistoryItem _$HistoryItemFromJson(Map<String, dynamic> json) {
  return _HistoryItem.fromJson(json);
}

/// @nodoc
mixin _$HistoryItem {
  String get id => throw _privateConstructorUsedError;
  String get peerName => throw _privateConstructorUsedError;
  int get fileCount => throw _privateConstructorUsedError;
  int get totalSizeBytes => throw _privateConstructorUsedError;
  int get timestampEpochMs => throw _privateConstructorUsedError;
  bool get isSent => throw _privateConstructorUsedError;
  bool get isSuccess => throw _privateConstructorUsedError;

  /// Serializes this HistoryItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HistoryItemCopyWith<HistoryItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HistoryItemCopyWith<$Res> {
  factory $HistoryItemCopyWith(
    HistoryItem value,
    $Res Function(HistoryItem) then,
  ) = _$HistoryItemCopyWithImpl<$Res, HistoryItem>;
  @useResult
  $Res call({
    String id,
    String peerName,
    int fileCount,
    int totalSizeBytes,
    int timestampEpochMs,
    bool isSent,
    bool isSuccess,
  });
}

/// @nodoc
class _$HistoryItemCopyWithImpl<$Res, $Val extends HistoryItem>
    implements $HistoryItemCopyWith<$Res> {
  _$HistoryItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? peerName = null,
    Object? fileCount = null,
    Object? totalSizeBytes = null,
    Object? timestampEpochMs = null,
    Object? isSent = null,
    Object? isSuccess = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            peerName: null == peerName
                ? _value.peerName
                : peerName // ignore: cast_nullable_to_non_nullable
                      as String,
            fileCount: null == fileCount
                ? _value.fileCount
                : fileCount // ignore: cast_nullable_to_non_nullable
                      as int,
            totalSizeBytes: null == totalSizeBytes
                ? _value.totalSizeBytes
                : totalSizeBytes // ignore: cast_nullable_to_non_nullable
                      as int,
            timestampEpochMs: null == timestampEpochMs
                ? _value.timestampEpochMs
                : timestampEpochMs // ignore: cast_nullable_to_non_nullable
                      as int,
            isSent: null == isSent
                ? _value.isSent
                : isSent // ignore: cast_nullable_to_non_nullable
                      as bool,
            isSuccess: null == isSuccess
                ? _value.isSuccess
                : isSuccess // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HistoryItemImplCopyWith<$Res>
    implements $HistoryItemCopyWith<$Res> {
  factory _$$HistoryItemImplCopyWith(
    _$HistoryItemImpl value,
    $Res Function(_$HistoryItemImpl) then,
  ) = __$$HistoryItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String peerName,
    int fileCount,
    int totalSizeBytes,
    int timestampEpochMs,
    bool isSent,
    bool isSuccess,
  });
}

/// @nodoc
class __$$HistoryItemImplCopyWithImpl<$Res>
    extends _$HistoryItemCopyWithImpl<$Res, _$HistoryItemImpl>
    implements _$$HistoryItemImplCopyWith<$Res> {
  __$$HistoryItemImplCopyWithImpl(
    _$HistoryItemImpl _value,
    $Res Function(_$HistoryItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? peerName = null,
    Object? fileCount = null,
    Object? totalSizeBytes = null,
    Object? timestampEpochMs = null,
    Object? isSent = null,
    Object? isSuccess = null,
  }) {
    return _then(
      _$HistoryItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        peerName: null == peerName
            ? _value.peerName
            : peerName // ignore: cast_nullable_to_non_nullable
                  as String,
        fileCount: null == fileCount
            ? _value.fileCount
            : fileCount // ignore: cast_nullable_to_non_nullable
                  as int,
        totalSizeBytes: null == totalSizeBytes
            ? _value.totalSizeBytes
            : totalSizeBytes // ignore: cast_nullable_to_non_nullable
                  as int,
        timestampEpochMs: null == timestampEpochMs
            ? _value.timestampEpochMs
            : timestampEpochMs // ignore: cast_nullable_to_non_nullable
                  as int,
        isSent: null == isSent
            ? _value.isSent
            : isSent // ignore: cast_nullable_to_non_nullable
                  as bool,
        isSuccess: null == isSuccess
            ? _value.isSuccess
            : isSuccess // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HistoryItemImpl implements _HistoryItem {
  const _$HistoryItemImpl({
    required this.id,
    required this.peerName,
    required this.fileCount,
    required this.totalSizeBytes,
    required this.timestampEpochMs,
    required this.isSent,
    required this.isSuccess,
  });

  factory _$HistoryItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$HistoryItemImplFromJson(json);

  @override
  final String id;
  @override
  final String peerName;
  @override
  final int fileCount;
  @override
  final int totalSizeBytes;
  @override
  final int timestampEpochMs;
  @override
  final bool isSent;
  @override
  final bool isSuccess;

  @override
  String toString() {
    return 'HistoryItem(id: $id, peerName: $peerName, fileCount: $fileCount, totalSizeBytes: $totalSizeBytes, timestampEpochMs: $timestampEpochMs, isSent: $isSent, isSuccess: $isSuccess)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HistoryItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.peerName, peerName) ||
                other.peerName == peerName) &&
            (identical(other.fileCount, fileCount) ||
                other.fileCount == fileCount) &&
            (identical(other.totalSizeBytes, totalSizeBytes) ||
                other.totalSizeBytes == totalSizeBytes) &&
            (identical(other.timestampEpochMs, timestampEpochMs) ||
                other.timestampEpochMs == timestampEpochMs) &&
            (identical(other.isSent, isSent) || other.isSent == isSent) &&
            (identical(other.isSuccess, isSuccess) ||
                other.isSuccess == isSuccess));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    peerName,
    fileCount,
    totalSizeBytes,
    timestampEpochMs,
    isSent,
    isSuccess,
  );

  /// Create a copy of HistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HistoryItemImplCopyWith<_$HistoryItemImpl> get copyWith =>
      __$$HistoryItemImplCopyWithImpl<_$HistoryItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HistoryItemImplToJson(this);
  }
}

abstract class _HistoryItem implements HistoryItem {
  const factory _HistoryItem({
    required final String id,
    required final String peerName,
    required final int fileCount,
    required final int totalSizeBytes,
    required final int timestampEpochMs,
    required final bool isSent,
    required final bool isSuccess,
  }) = _$HistoryItemImpl;

  factory _HistoryItem.fromJson(Map<String, dynamic> json) =
      _$HistoryItemImpl.fromJson;

  @override
  String get id;
  @override
  String get peerName;
  @override
  int get fileCount;
  @override
  int get totalSizeBytes;
  @override
  int get timestampEpochMs;
  @override
  bool get isSent;
  @override
  bool get isSuccess;

  /// Create a copy of HistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HistoryItemImplCopyWith<_$HistoryItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
