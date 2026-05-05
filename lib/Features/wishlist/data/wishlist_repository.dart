import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toko_oli/core/data/app_fallback_store.dart';
import 'package:toko_oli/features/product/domain/product.dart';
import 'package:toko_oli/features/product/presentation/data/product_repository.dart';

class WishlistRepository {
  WishlistRepository(this._productRepository, {SupabaseClient? client})
      : _client = client,
        _fallback = AppFallbackStore.instance;

  final SupabaseClient? _client;
  final ProductRepository _productRepository;
  final AppFallbackStore _fallback;

  Future<List<Product>> getWishlist(String userId) async {
    final client = _client;
    if (client != null) {
      try {
        final response = await client
            .from('wishlist_items')
            .select('product_id')
            .eq('user_id', userId);
        final ids = (response as List<dynamic>)
            .map((item) => item['product_id'].toString())
            .toSet();
        final products = await _productRepository.getActiveProducts();
        return products.where((product) => ids.contains(product.id)).toList();
      } catch (_) {}
    }
    final products = await _productRepository.getActiveProducts();
    return products
        .where((product) => _fallback.wishlistProductIds.contains(product.id))
        .toList();
  }

  Future<void> addToWishlist(String userId, String productId) async {
    final client = _client;
    if (client != null) {
      try {
        await client
            .from('wishlist_items')
            .upsert({'user_id': userId, 'product_id': productId});
        return;
      } catch (_) {}
    }
    if (!_fallback.wishlistProductIds.contains(productId)) {
      _fallback.wishlistProductIds.add(productId);
    }
  }

  Future<void> removeFromWishlist(String userId, String productId) async {
    final client = _client;
    if (client != null) {
      try {
        await client
            .from('wishlist_items')
            .delete()
            .eq('user_id', userId)
            .eq('product_id', productId);
        return;
      } catch (_) {}
    }
    _fallback.wishlistProductIds.remove(productId);
  }
}
