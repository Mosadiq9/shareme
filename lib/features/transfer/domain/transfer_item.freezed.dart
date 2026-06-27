// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TransferItem _$TransferItemFromJson(Map<String, dynamic> json) {
  return _TransferItem.fromJson(json);
}

/// @nodoc
mixin _$TransferItem {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get sizeBytes => throw _privateConstructorUsedError;
  String get mimeType => throw _privateConstructorUsedError;
  double get progress => throw _privateConstructorUsedError;
  TransferItemStatus get status => throw _privateConstructorUsedError;

  /// Serializes this TransferItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransferItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransferItemCopyWith<TransferItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferItemCopyWith<$Res> {
  factory $TransferItemCopyWith(
    TransferItem value,
    $Res Function(TransferItem) then,
  ) = _$TransferItemCopyWithImpl<$Res, TransferItem>;
  @useResult
  $Res call({
    String id,
    String name,
    int sizeBytes,
    String mimeType,
    double progress,
    TransferItemStatus status,
  });
}

/// @nodoc
class _$TransferItemCopyWithImpl<$Res, $Val extends TransferItem>
    implements $TransferItemCopyWith<$Res> {
  _$TransferItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransferItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? sizeBytes = null,
    Object? mimeType = null,
    Object? progress = null,
    Object? status = null,
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
            sizeBytes: null == sizeBytes
                ? _value.sizeBytes
                : sizeBytes // ignore: cast_nullable_to_non_nullable
                      as int,
            mimeType: null == mimeType
                ? _value.mimeType
                : mimeType // ignore: cast_nullable_to_non_nullable
                      as String,
            progress: null == progress
                ? _value.progress
                : progress // ignore: cast_nullable_to_non_nullable
                      as double,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as TransferItemStatus,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransferItemImplCopyWith<$Res>
    implements $TransferItemCopyWith<$Res> {
  factory _$$TransferItemImplCopyWith(
    _$TransferItemImpl value,
    $Res Function(_$TransferItemImpl) then,
  ) = __$$TransferItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    int sizeBytes,
    String mimeType,
    double progress,
    TransferItemStatus status,
  });
}

/// @nodoc
class __$$TransferItemImplCopyWithImpl<$Res>
    extends _$TransferItemCopyWithImpl<$Res, _$TransferItemImpl>
    implements _$$TransferItemImplCopyWith<$Res> {
  __$$TransferItemImplCopyWithImpl(
    _$TransferItemImpl _value,
    $Res Function(_$TransferItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransferItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? sizeBytes = null,
    Object? mimeType = null,
    Object? progress = null,
    Object? status = null,
  }) {
    return _then(
      _$TransferItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        sizeBytes: null == sizeBytes
            ? _value.sizeBytes
            : sizeBytes // ignore: cast_nullable_to_non_nullable
                  as int,
        mimeType: null == mimeType
            ? _value.mimeType
            : mimeType // ignore: cast_nullable_to_non_nullable
                  as String,
        progress: null == progress
            ? _value.progress
            : progress // ignore: cast_nullable_to_non_nullable
                  as double,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as TransferItemStatus,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TransferItemImpl implements _TransferItem {
  const _$TransferItemImpl({
    required this.id,
    required this.name,
    required this.sizeBytes,
    required this.mimeType,
    this.progress = 0.0,
    this.status = TransferItemStatus.pending,
  });

  factory _$TransferItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransferItemImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final int sizeBytes;
  @override
  final String mimeType;
  @override
  @JsonKey()
  final double progress;
  @override
  @JsonKey()
  final TransferItemStatus status;

  @override
  String toString() {
    return 'TransferItem(id: $id, name: $name, sizeBytes: $sizeBytes, mimeType: $mimeType, progress: $progress, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.sizeBytes, sizeBytes) ||
                other.sizeBytes == sizeBytes) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, sizeBytes, mimeType, progress, status);

  /// Create a copy of TransferItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferItemImplCopyWith<_$TransferItemImpl> get copyWith =>
      __$$TransferItemImplCopyWithImpl<_$TransferItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransferItemImplToJson(this);
  }
}

abstract class _TransferItem implements TransferItem {
  const factory _TransferItem({
    required final String id,
    required final String name,
    required final int sizeBytes,
    required final String mimeType,
    final double progress,
    final TransferItemStatus status,
  }) = _$TransferItemImpl;

  factory _TransferItem.fromJson(Map<String, dynamic> json) =
      _$TransferItemImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  int get sizeBytes;
  @override
  String get mimeType;
  @override
  double get progress;
  @override
  TransferItemStatus get status;

  /// Create a copy of TransferItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransferItemImplCopyWith<_$TransferItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
