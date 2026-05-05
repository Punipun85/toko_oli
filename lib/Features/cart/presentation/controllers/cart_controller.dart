import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toko_oli/core/providers/app_providers.dart';
import 'package:toko_oli/features/auth/data/auth_repository.dart';
import 'package:toko_oli/features/cart/domain/cart_item.dart';
import 'package:toko_oli/features/product/domain/product.dart';

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier(this._ref) : super([]) {
    _load();
  }

  final Ref _ref;

  Future<void> _load() async {
    final user = await _ref.read(currentUserProvider.future);
    state = await _ref.read(cartRepositoryProvider).getCartItems(user?.id);
  }

  Future<void> refresh() => _load();

  Future<void> addProduct(
    Product product, {
    String unit = 'pcs',
    int quantity = 1,
    int? pcsPerDos,
  }) async {
    final user = await _ref.read(currentUserProvider.future);
    state = await _ref.read(cartRepositoryProvider).addToCart(
          user?.id,
          product,
          unit: unit,
          quantity: quantity,
          pcsPerDos: pcsPerDos,
        );
  }

  Future<void> removeProduct(String productId, String unit) async {
    final user = await _ref.read(currentUserProvider.future);
    state = await _ref
        .read(cartRepositoryProvider)
        .removeItem(user?.id, productId, unit);
  }

  Future<void> updateQuantity(String productId, String unit, int quantity) async {
    final user = await _ref.read(currentUserProvider.future);
    state = await _ref
        .read(cartRepositoryProvider)
        .updateQuantity(user?.id, productId, unit, quantity);
  }

  Future<void> clearCart() async {
    final user = await _ref.read(currentUserProvider.future);
    await _ref.read(cartRepositoryProvider).clearCart(user?.id);
    state = [];
  }

  Future<bool> validateStockBeforeCheckout() async {
    return _ref.read(cartRepositoryProvider).validateStockBeforeCheckout(state);
  }

  num get totalPrice {
    return state.fold(0, (total, item) => total + item.subtotal);
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier(ref);
});
