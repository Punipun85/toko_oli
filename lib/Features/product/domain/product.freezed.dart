// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Product {

@JsonKey(name: 'id_produk', fromJson: _parseString) String get id;@JsonKey(name: 'nama_produk', fromJson: _parseStringEmpty) String get name;@JsonKey(name: 'harga', fromJson: _parsePrice) num get priceValue;@JsonKey(name: 'sae', fromJson: _parseStringDash) String get sae;@JsonKey(name: 'volume', fromJson: _parseStringDash) String get volume;@JsonKey(name: 'tipe', fromJson: _parseStringDash) String get type;@JsonKey(name: 'seri', fromJson: _parseStringDash) String get series;@JsonKey(name: 'deskripsi', fromJson: _parseStringDesc) String get description;@JsonKey(name: 'gambar') String? get imageUrl;@JsonKey(name: 'merk', fromJson: _extractMerk) String get brand;@JsonKey(name: 'kategori', fromJson: _extractCategory) String get category;
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCopyWith<Product> get copyWith => _$ProductCopyWithImpl<Product>(this as Product, _$identity);

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Product&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.priceValue, priceValue) || other.priceValue == priceValue)&&(identical(other.sae, sae) || other.sae == sae)&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.type, type) || other.type == type)&&(identical(other.series, series) || other.series == series)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,priceValue,sae,volume,type,series,description,imageUrl,brand,category);

@override
String toString() {
  return 'Product(id: $id, name: $name, priceValue: $priceValue, sae: $sae, volume: $volume, type: $type, series: $series, description: $description, imageUrl: $imageUrl, brand: $brand, category: $category)';
}


}

/// @nodoc
abstract mixin class $ProductCopyWith<$Res>  {
  factory $ProductCopyWith(Product value, $Res Function(Product) _then) = _$ProductCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id_produk', fromJson: _parseString) String id,@JsonKey(name: 'nama_produk', fromJson: _parseStringEmpty) String name,@JsonKey(name: 'harga', fromJson: _parsePrice) num priceValue,@JsonKey(name: 'sae', fromJson: _parseStringDash) String sae,@JsonKey(name: 'volume', fromJson: _parseStringDash) String volume,@JsonKey(name: 'tipe', fromJson: _parseStringDash) String type,@JsonKey(name: 'seri', fromJson: _parseStringDash) String series,@JsonKey(name: 'deskripsi', fromJson: _parseStringDesc) String description,@JsonKey(name: 'gambar') String? imageUrl,@JsonKey(name: 'merk', fromJson: _extractMerk) String brand,@JsonKey(name: 'kategori', fromJson: _extractCategory) String category
});




}
/// @nodoc
class _$ProductCopyWithImpl<$Res>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._self, this._then);

  final Product _self;
  final $Res Function(Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? priceValue = null,Object? sae = null,Object? volume = null,Object? type = null,Object? series = null,Object? description = null,Object? imageUrl = freezed,Object? brand = null,Object? category = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,priceValue: null == priceValue ? _self.priceValue : priceValue // ignore: cast_nullable_to_non_nullable
as num,sae: null == sae ? _self.sae : sae // ignore: cast_nullable_to_non_nullable
as String,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,series: null == series ? _self.series : series // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Product].
extension ProductPatterns on Product {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Product value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Product value)  $default,){
final _that = this;
switch (_that) {
case _Product():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Product value)?  $default,){
final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id_produk', fromJson: _parseString)  String id, @JsonKey(name: 'nama_produk', fromJson: _parseStringEmpty)  String name, @JsonKey(name: 'harga', fromJson: _parsePrice)  num priceValue, @JsonKey(name: 'sae', fromJson: _parseStringDash)  String sae, @JsonKey(name: 'volume', fromJson: _parseStringDash)  String volume, @JsonKey(name: 'tipe', fromJson: _parseStringDash)  String type, @JsonKey(name: 'seri', fromJson: _parseStringDash)  String series, @JsonKey(name: 'deskripsi', fromJson: _parseStringDesc)  String description, @JsonKey(name: 'gambar')  String? imageUrl, @JsonKey(name: 'merk', fromJson: _extractMerk)  String brand, @JsonKey(name: 'kategori', fromJson: _extractCategory)  String category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.name,_that.priceValue,_that.sae,_that.volume,_that.type,_that.series,_that.description,_that.imageUrl,_that.brand,_that.category);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id_produk', fromJson: _parseString)  String id, @JsonKey(name: 'nama_produk', fromJson: _parseStringEmpty)  String name, @JsonKey(name: 'harga', fromJson: _parsePrice)  num priceValue, @JsonKey(name: 'sae', fromJson: _parseStringDash)  String sae, @JsonKey(name: 'volume', fromJson: _parseStringDash)  String volume, @JsonKey(name: 'tipe', fromJson: _parseStringDash)  String type, @JsonKey(name: 'seri', fromJson: _parseStringDash)  String series, @JsonKey(name: 'deskripsi', fromJson: _parseStringDesc)  String description, @JsonKey(name: 'gambar')  String? imageUrl, @JsonKey(name: 'merk', fromJson: _extractMerk)  String brand, @JsonKey(name: 'kategori', fromJson: _extractCategory)  String category)  $default,) {final _that = this;
switch (_that) {
case _Product():
return $default(_that.id,_that.name,_that.priceValue,_that.sae,_that.volume,_that.type,_that.series,_that.description,_that.imageUrl,_that.brand,_that.category);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id_produk', fromJson: _parseString)  String id, @JsonKey(name: 'nama_produk', fromJson: _parseStringEmpty)  String name, @JsonKey(name: 'harga', fromJson: _parsePrice)  num priceValue, @JsonKey(name: 'sae', fromJson: _parseStringDash)  String sae, @JsonKey(name: 'volume', fromJson: _parseStringDash)  String volume, @JsonKey(name: 'tipe', fromJson: _parseStringDash)  String type, @JsonKey(name: 'seri', fromJson: _parseStringDash)  String series, @JsonKey(name: 'deskripsi', fromJson: _parseStringDesc)  String description, @JsonKey(name: 'gambar')  String? imageUrl, @JsonKey(name: 'merk', fromJson: _extractMerk)  String brand, @JsonKey(name: 'kategori', fromJson: _extractCategory)  String category)?  $default,) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.name,_that.priceValue,_that.sae,_that.volume,_that.type,_that.series,_that.description,_that.imageUrl,_that.brand,_that.category);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Product extends Product {
  const _Product({@JsonKey(name: 'id_produk', fromJson: _parseString) required this.id, @JsonKey(name: 'nama_produk', fromJson: _parseStringEmpty) required this.name, @JsonKey(name: 'harga', fromJson: _parsePrice) required this.priceValue, @JsonKey(name: 'sae', fromJson: _parseStringDash) required this.sae, @JsonKey(name: 'volume', fromJson: _parseStringDash) required this.volume, @JsonKey(name: 'tipe', fromJson: _parseStringDash) required this.type, @JsonKey(name: 'seri', fromJson: _parseStringDash) required this.series, @JsonKey(name: 'deskripsi', fromJson: _parseStringDesc) required this.description, @JsonKey(name: 'gambar') this.imageUrl, @JsonKey(name: 'merk', fromJson: _extractMerk) this.brand = 'Pertamina', @JsonKey(name: 'kategori', fromJson: _extractCategory) this.category = 'Oli'}): super._();
  factory _Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

@override@JsonKey(name: 'id_produk', fromJson: _parseString) final  String id;
@override@JsonKey(name: 'nama_produk', fromJson: _parseStringEmpty) final  String name;
@override@JsonKey(name: 'harga', fromJson: _parsePrice) final  num priceValue;
@override@JsonKey(name: 'sae', fromJson: _parseStringDash) final  String sae;
@override@JsonKey(name: 'volume', fromJson: _parseStringDash) final  String volume;
@override@JsonKey(name: 'tipe', fromJson: _parseStringDash) final  String type;
@override@JsonKey(name: 'seri', fromJson: _parseStringDash) final  String series;
@override@JsonKey(name: 'deskripsi', fromJson: _parseStringDesc) final  String description;
@override@JsonKey(name: 'gambar') final  String? imageUrl;
@override@JsonKey(name: 'merk', fromJson: _extractMerk) final  String brand;
@override@JsonKey(name: 'kategori', fromJson: _extractCategory) final  String category;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCopyWith<_Product> get copyWith => __$ProductCopyWithImpl<_Product>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Product&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.priceValue, priceValue) || other.priceValue == priceValue)&&(identical(other.sae, sae) || other.sae == sae)&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.type, type) || other.type == type)&&(identical(other.series, series) || other.series == series)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,priceValue,sae,volume,type,series,description,imageUrl,brand,category);

@override
String toString() {
  return 'Product(id: $id, name: $name, priceValue: $priceValue, sae: $sae, volume: $volume, type: $type, series: $series, description: $description, imageUrl: $imageUrl, brand: $brand, category: $category)';
}


}

/// @nodoc
abstract mixin class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) _then) = __$ProductCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id_produk', fromJson: _parseString) String id,@JsonKey(name: 'nama_produk', fromJson: _parseStringEmpty) String name,@JsonKey(name: 'harga', fromJson: _parsePrice) num priceValue,@JsonKey(name: 'sae', fromJson: _parseStringDash) String sae,@JsonKey(name: 'volume', fromJson: _parseStringDash) String volume,@JsonKey(name: 'tipe', fromJson: _parseStringDash) String type,@JsonKey(name: 'seri', fromJson: _parseStringDash) String series,@JsonKey(name: 'deskripsi', fromJson: _parseStringDesc) String description,@JsonKey(name: 'gambar') String? imageUrl,@JsonKey(name: 'merk', fromJson: _extractMerk) String brand,@JsonKey(name: 'kategori', fromJson: _extractCategory) String category
});




}
/// @nodoc
class __$ProductCopyWithImpl<$Res>
    implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(this._self, this._then);

  final _Product _self;
  final $Res Function(_Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? priceValue = null,Object? sae = null,Object? volume = null,Object? type = null,Object? series = null,Object? description = null,Object? imageUrl = freezed,Object? brand = null,Object? category = null,}) {
  return _then(_Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,priceValue: null == priceValue ? _self.priceValue : priceValue // ignore: cast_nullable_to_non_nullable
as num,sae: null == sae ? _self.sae : sae // ignore: cast_nullable_to_non_nullable
as String,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,series: null == series ? _self.series : series // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
