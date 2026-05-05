import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:toko_oli/features/product/domain/product.dart';

part 'cart_item.freezed.dart';
part 'cart_item.g.dart';

@freezed
abstract class CartItem with _$CartItem {
  const factory CartItem({
    required Product product,
    @Default(1) int quantity,
    @Default('pcs') String unit,
    int? pcsPerDos,
  }) = _CartItem;

  factory CartItem.fromJson(Map<String, dynamic> json) => _$CartItemFromJson(json);

  const CartItem._();

  num get subtotal {
    if (unit == 'dos' && pcsPerDos != null) {
      return product.priceValue * quantity * pcsPerDos!;
    }
    return product.priceValue * quantity;
  }
}
