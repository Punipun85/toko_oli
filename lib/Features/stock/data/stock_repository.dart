import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toko_oli/core/data/app_fallback_store.dart';
import 'package:toko_oli/core/models/app_entities.dart';
import 'package:toko_oli/features/product/presentation/data/product_repository.dart';

class StockRepository {
  StockRepository(this._productRepository, {SupabaseClient? client})
      : _client = client,
        _fallback = AppFallbackStore.instance;

  final SupabaseClient? _client;
  final ProductRepository _productRepository;
  final AppFallbackStore _fallback;

  Future<List<ProductVariantInfo>> adminGetStockSummary() async {
    final activeProducts = await _productRepository.getActiveProducts();
    final variants = <ProductVariantInfo>[];
    for (final product in activeProducts) {
      variants.addAll(await _productRepository.getProductVariants(product.id));
    }
    return variants;
  }

  Future<void> adminStockIn(String variantId, int quantity) async {
    await _changeStock(variantId, quantity, 'purchase');
  }

  Future<void> adminStockOut(String variantId, int quantity) async {
    await _changeStock(variantId, -quantity, 'sale');
  }

  Future<void> adminStockAdjustment(String variantId, int quantity) async {
    await _changeStock(variantId, quantity, 'adjustment');
  }

  Future<List<StockMovementInfo>> adminGetStockMovements() async {
    final client = _client;
    if (client != null) {
      try {
        final response = await client
            .from('stock_movements')
            .select()
            .order('created_at', ascending: false);
        return (response as List<dynamic>).map(_mapMovement).toList();
      } catch (_) {}
    }
    return List<StockMovementInfo>.from(_fallback.stockMovements);
  }

  Future<void> _changeStock(String variantId, int delta, String movementType) async {
    final allVariants = await adminGetStockSummary();
    final variant = allVariants.firstWhere((item) => item.id == variantId);
    final newStock = variant.stockQuantity + delta;
    if (newStock < 0) {
      throw Exception('Stok tidak boleh kurang dari nol.');
    }

    final client = _client;
    if (client != null) {
      try {
        await client.from('product_variants').update({
          'stock_quantity': newStock,
        }).eq('id', variantId);
        await client.from('stock_movements').insert({
          'variant_id': variant.id,
          'product_id': variant.productId,
          'movement_type': movementType,
          'quantity': delta,
        });
        return;
      } catch (_) {}
    }

    final index = _fallback.variants.indexWhere((item) => item.id == variantId);
    if (index >= 0) {
      final old = _fallback.variants[index];
      _fallback.variants[index] = ProductVariantInfo(
        id: old.id,
        productId: old.productId,
        name: old.name,
        sku: old.sku,
        price: old.price,
        stockQuantity: newStock,
        barcode: old.barcode,
        minimumStock: old.minimumStock,
        volumeLabel: old.volumeLabel,
      );
    }
    _fallback.stockMovements.add(
      StockMovementInfo(
        id: 'move-${DateTime.now().millisecondsSinceEpoch}',
        variantId: variantId,
        productId: variant.productId,
        movementType: movementType,
        quantity: delta,
        createdAt: DateTime.now(),
      ),
    );
  }

  StockMovementInfo _mapMovement(dynamic raw) {
    final item = raw as Map<String, dynamic>;
    return StockMovementInfo(
      id: item['id'].toString(),
      variantId: item['variant_id'].toString(),
      productId: item['product_id'].toString(),
      movementType: (item['movement_type'] ?? '').toString(),
      quantity: (item['quantity'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.tryParse((item['created_at'] ?? '').toString()) ??
          DateTime.now(),
    );
  }
}
