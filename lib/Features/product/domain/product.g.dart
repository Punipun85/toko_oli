// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: _parseString(json['id_produk']),
  name: _parseStringEmpty(json['nama_produk']),
  priceValue: _parsePrice(json['harga']),
  sae: _parseStringDash(json['sae']),
  volume: _parseStringDash(json['volume']),
  type: _parseStringDash(json['tipe']),
  series: _parseStringDash(json['seri']),
  description: _parseStringDesc(json['deskripsi']),
  imageUrl: json['gambar'] as String?,
  brand: json['merk'] == null ? 'Pertamina' : _extractMerk(json['merk']),
  category: json['kategori'] == null
      ? 'Oli'
      : _extractCategory(json['kategori']),
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id_produk': instance.id,
  'nama_produk': instance.name,
  'harga': instance.priceValue,
  'sae': instance.sae,
  'volume': instance.volume,
  'tipe': instance.type,
  'seri': instance.series,
  'deskripsi': instance.description,
  'gambar': instance.imageUrl,
  'merk': instance.brand,
  'kategori': instance.category,
};
