import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toko_oli/core/data/app_fallback_store.dart';
import 'package:toko_oli/features/cart/domain/cart_item.dart';
import 'package:toko_oli/features/product/domain/product.dart';
import 'package:toko_oli/features/product/presentation/data/product_repository.dart';

class CartRepository {
  CartRepository(this._productRepository, {SupabaseClient? client})
      : _client = client,
        _fallback = AppFallbackStore.instance;

  final SupabaseClient? _client;
  final ProductRepository _productRepository;
  final AppFallbackStore _fallback;

  Future<List<CartItem>> getCartItems(String? userId) async {
    final client = _client;
    if (client != null && userId != null) {
      try {
        final cart = await client
            .from('carts')
            .select('id')
            .eq('user_id', userId)
            .eq('status', 'active')
            .maybeSingle();

        if (cart == null) {
          return List<CartItem>.from(_fallback.cartItems);
        }

        final items = await client.from('cart_items').select('''
id,
quantity,
variant_id,
products:product_id(
  id,
  name,
  description,
  viscosity,
  product_type,
  series,
  brands:brand_id(name),
  categories:category_id(name),
  product_images(image_url,is_primary)
),
product_variants:variant_id(id,price,volume_label)
''').eq('cart_id', cart['id']);

        return (items as List<dynamic>).map((item) {
          final row = item as Map<String, dynamic>;
          final productRow = row['products'] as Map<String, dynamic>;
          final variantRow = row['product_variants'] as Map<String, dynamic>;
          final imageList =
              productRow['product_images'] as List<dynamic>? ?? const [];
          final image = imageList.isNotEmpty
              ? (imageList.first as Map<String, dynamic>)['image_url']?.toString()
              : null;
          final product = Product(
            id: productRow['id'].toString(),
            name: (productRow['name'] ?? '').toString(),
            priceValue: (variantRow['price'] as num?) ?? 0,
            sae: (productRow['viscosity'] ?? '-').toString(),
            volume: (variantRow['volume_label'] ?? '-').toString(),
            type: (productRow['product_type'] ?? '-').toString(),
            series: (productRow['series'] ?? '-').toString(),
            description: (productRow['description'] ?? '').toString(),
            imageUrl: image,
            brand: _nestedName(productRow['brands']),
            category: _nestedName(productRow['categories']),
          );
          return CartItem(
            product: product,
            quantity: (row['quantity'] as num?)?.toInt() ?? 1,
            unit: 'pcs',
          );
        }).toList();
      } catch (_) {}
    }

    return List<CartItem>.from(_fallback.cartItems);
  }

  Future<List<CartItem>> addToCart(
    String? userId,
    Product product, {
    String unit = 'pcs',
    int quantity = 1,
    int? pcsPerDos,
  }) async {
    final safeQuantity = quantity < 1 ? 1 : quantity;
    final items = List<CartItem>.from(_fallback.cartItems);
    final index = items.indexWhere(
      (item) => item.product.id == product.id && item.unit == unit,
    );

    if (index >= 0) {
      items[index] = items[index].copyWith(
        quantity: items[index].quantity + safeQuantity,
        pcsPerDos: pcsPerDos ?? items[index].pcsPerDos,
      );
    } else {
      items.add(
        CartItem(
          product: product,
          unit: unit,
          quantity: safeQuantity,
          pcsPerDos: pcsPerDos,
        ),
      );
    }

    _fallback.cartItems
      ..clear()
      ..addAll(items);

    final client = _client;
    if (client != null && userId != null) {
      try {
        final cart = await _ensureActiveCart(userId);
        final variant = await _resolveVariant(product.id);
        if (variant != null) {
          final existing = await client
              .from('cart_items')
              .select('id,quantity')
              .eq('cart_id', cart['id'])
              .eq('variant_id', variant.id)
              .maybeSingle();
          if (existing == null) {
            await client.from('cart_items').insert({
              'cart_id': cart['id'],
              'product_id': product.id,
              'variant_id': variant.id,
              'quantity': safeQuantity,
              'unit_price': variant.price,
            });
          } else {
            await client.from('cart_items').update({
              'quantity': ((existing['quantity'] as num?)?.toInt() ?? 0) + safeQuantity,
            }).eq('id', existing['id']);
          }
        }
      } catch (_) {}
    }

    return items;
  }

  Future<List<CartItem>> updateQuantity(
    String? userId,
    String productId,
    String unit,
    int quantity,
  ) async {
    if (quantity <= 0) {
      return removeItem(userId, productId, unit);
    }

    final updated = [
      for (final item in _fallback.cartItems)
        if (item.product.id == productId && item.unit == unit)
          item.copyWith(quantity: quantity)
        else
          item,
    ];
    _fallback.cartItems
      ..clear()
      ..addAll(updated);

    final client = _client;
    if (client != null && userId != null) {
      try {
        final cart = await _ensureActiveCart(userId);
        final variant = await _resolveVariant(productId);
        if (variant != null) {
          await client.from('cart_items').update({'quantity': quantity}).eq(
            'cart_id',
            cart['id'],
          ).eq('variant_id', variant.id);
        }
      } catch (_) {}
    }

    return updated;
  }

  Future<List<CartItem>> removeItem(
    String? userId,
    String productId,
    String unit,
  ) async {
    final updated = _fallback.cartItems
        .where((item) => !(item.product.id == productId && item.unit == unit))
        .toList();
    _fallback.cartItems
      ..clear()
      ..addAll(updated);

    final client = _client;
    if (client != null && userId != null) {
      try {
        final cart = await _ensureActiveCart(userId);
        final variant = await _resolveVariant(productId);
        if (variant != null) {
          await client
              .from('cart_items')
              .delete()
              .eq('cart_id', cart['id'])
              .eq('variant_id', variant.id);
        }
      } catch (_) {}
    }

    return updated;
  }

  Future<void> clearCart(String? userId) async {
    _fallback.cartItems.clear();
    final client = _client;
    if (client != null && userId != null) {
      try {
        final cart = await _ensureActiveCart(userId);
        await client.from('cart_items').delete().eq('cart_id', cart['id']);
      } catch (_) {}
    }
  }

  Future<bool> validateStockBeforeCheckout(List<CartItem> items) async {
    for (final item in items) {
      final variants = await _productRepository.getProductVariants(item.product.id);
      final variant = variants.isEmpty ? null : variants.first;
      if (variant != null && variant.stockQuantity < item.quantity) {
        return false;
      }
    }
    return true;
  }

  Future<Map<String, dynamic>> _ensureActiveCart(String userId) async {
    final client = _client;
    if (client == null) {
      throw StateError('Supabase client belum tersedia.');
    }

    final existing = await client
        .from('carts')
        .select('id,user_id,status')
        .eq('user_id', userId)
        .eq('status', 'active')
        .maybeSingle();

    if (existing != null) {
      return existing;
    }

    final created = await client
        .from('carts')
        .insert({'user_id': userId, 'status': 'active'})
        .select('id,user_id,status')
        .single();
    return created;
  }

  Future<dynamic> _resolveVariant(String productId) async {
    final variants = await _productRepository.getProductVariants(productId);
    return variants.isEmpty ? null : variants.first;
  }

  String _nestedName(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      return (raw['name'] ?? '').toString();
    }
    if (raw is List && raw.isNotEmpty && raw.first is Map<String, dynamic>) {
      return ((raw.first as Map<String, dynamic>)['name'] ?? '').toString();
    }
    return '';
  }
}
