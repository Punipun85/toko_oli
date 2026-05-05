// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CartItem _$CartItemFromJson(Map<String, dynamic> json) => _CartItem(
  product: Product.fromJson(json['product'] as Map<String, dynamic>),
  quantity: (json['quantity'] as num?)?.toInt() ?? 1,
  unit: json['unit'] as String? ?? 'pcs',
  pcsPerDos: (json['pcsPerDos'] as num?)?.toInt(),
);

Map<String, dynamic> _$CartItemToJson(_CartItem instance) => <String, dynamic>{
  'product': instance.product,
  'quantity': instance.quantity,
  'unit': instance.unit,
  'pcsPerDos': instance.pcsPerDos,
};
