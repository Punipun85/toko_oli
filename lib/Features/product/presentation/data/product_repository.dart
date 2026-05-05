import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toko_oli/core/data/app_fallback_store.dart';
import 'package:toko_oli/core/models/app_entities.dart';
import 'package:toko_oli/features/product/domain/product.dart';

class ProductRepository {
  ProductRepository({SupabaseClient? client})
      : _client = client,
        _fallback = AppFallbackStore.instance;

  final SupabaseClient? _client;
  final AppFallbackStore _fallback;

  Future<List<Product>> fetchProducts() => getActiveProducts();

  Future<List<Product>> getActiveProducts() async {
    final fromNewSchema = await _tryGetActiveProductsFromNewSchema();
    if (fromNewSchema != null && fromNewSchema.isNotEmpty) {
      return fromNewSchema;
    }

    final fromLegacySchema = await _tryGetActiveProductsFromLegacySchema();
    if (fromLegacySchema != null && fromLegacySchema.isNotEmpty) {
      return fromLegacySchema;
    }

    return List<Product>.from(_fallback.products);
  }

  Future<Product?> getProductById(String id) async {
    final products = await getActiveProducts();
    for (final product in products) {
      if (product.id == id) {
        return product;
      }
    }
    return null;
  }

  Future<List<Product>> searchProducts(String query) async {
    final products = await getActiveProducts();
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return products;
    }

    return products.where((product) {
      final haystack = [
        product.name,
        product.brand,
        product.sae,
        product.type,
        product.category,
        product.series,
      ].join(' ').toLowerCase();
      return haystack.contains(normalized);
    }).toList();
  }

  Future<List<Product>> filterProducts({
    String? brand,
    String? category,
    String? viscosity,
    String? vehicleType,
    String? engineType,
  }) async {
    final products = await getActiveProducts();
    return products.where((product) {
      final matchBrand = brand == null || brand.isEmpty || product.brand == brand;
      final matchCategory =
          category == null || category.isEmpty || product.category == category;
      final matchViscosity =
          viscosity == null || viscosity.isEmpty || product.sae == viscosity;
      final matchVehicleType = vehicleType == null || vehicleType.isEmpty;
      final matchEngineType = engineType == null || engineType.isEmpty;
      return matchBrand &&
          matchCategory &&
          matchViscosity &&
          matchVehicleType &&
          matchEngineType;
    }).toList();
  }

  Future<List<BrandInfo>> getBrands() async {
    final client = _client;
    if (client != null) {
      try {
        final response = await client
            .from('brands')
            .select('id,name,slug,is_active')
            .eq('is_active', true)
            .order('name');

        return (response as List<dynamic>)
            .map(
              (item) => BrandInfo(
                id: item['id'].toString(),
                name: item['name'].toString(),
                slug: (item['slug'] ?? '').toString(),
                isActive: item['is_active'] == true,
              ),
            )
            .toList();
      } catch (_) {}

      try {
        final response = await client
            .from('merk')
            .select('id_merk,nama_merk')
            .order('nama_merk');
        return (response as List<dynamic>)
            .map(
              (item) => BrandInfo(
                id: item['id_merk'].toString(),
                name: item['nama_merk'].toString(),
                slug: item['nama_merk'].toString().toLowerCase().replaceAll(' ', '-'),
              ),
            )
            .toList();
      } catch (_) {}
    }

    return List<BrandInfo>.from(_fallback.brands);
  }

  Future<List<CategoryInfo>> getCategories() async {
    final client = _client;
    if (client != null) {
      try {
        final response = await client
            .from('categories')
            .select('id,name,slug,is_active')
            .eq('is_active', true)
            .order('sort_order');

        return (response as List<dynamic>)
            .map(
              (item) => CategoryInfo(
                id: item['id'].toString(),
                name: item['name'].toString(),
                slug: (item['slug'] ?? '').toString(),
                isActive: item['is_active'] == true,
              ),
            )
            .toList();
      } catch (_) {}

      try {
        final response = await client
            .from('kategori')
            .select('id_kategori,nama_kategori')
            .order('nama_kategori');
        return (response as List<dynamic>)
            .map(
              (item) => CategoryInfo(
                id: item['id_kategori'].toString(),
                name: item['nama_kategori'].toString(),
                slug:
                    item['nama_kategori'].toString().toLowerCase().replaceAll(' ', '-'),
              ),
            )
            .toList();
      } catch (_) {}
    }

    return List<CategoryInfo>.from(_fallback.categories);
  }

  Future<List<ProductVariantInfo>> getProductVariants(String productId) async {
    final client = _client;
    if (client != null) {
      try {
        final response = await client
            .from('product_variants')
            .select(
              'id,product_id,name,sku,barcode,price,stock_quantity,minimum_stock,volume_label',
            )
            .eq('product_id', productId)
            .eq('is_active', true)
            .order('name');

        return (response as List<dynamic>)
            .map(
              (item) => ProductVariantInfo(
                id: item['id'].toString(),
                productId: item['product_id'].toString(),
                name: item['name'].toString(),
                sku: item['sku'].toString(),
                barcode: item['barcode']?.toString(),
                price: (item['price'] as num?)?.toDouble() ?? 0,
                stockQuantity: (item['stock_quantity'] as num?)?.toInt() ?? 0,
                minimumStock: (item['minimum_stock'] as num?)?.toInt() ?? 0,
                volumeLabel: (item['volume_label'] ?? '').toString(),
              ),
            )
            .toList();
      } catch (_) {}
    }

    return _fallback.variants.where((variant) => variant.productId == productId).toList();
  }

  Future<List<ProductVariantInfo>> getLowStockProducts() async {
    final client = _client;
    if (client != null) {
      try {
        final response = await client.from('low_stock_products').select();
        return (response as List<dynamic>)
            .map(
              (item) => ProductVariantInfo(
                id: item['variant_id'].toString(),
                productId: item['product_id'].toString(),
                name: item['variant_name'].toString(),
                sku: item['variant_id'].toString(),
                price: 0,
                stockQuantity: (item['current_stock'] as num?)?.toInt() ?? 0,
                minimumStock: (item['minimum_stock'] as num?)?.toInt() ?? 0,
                volumeLabel: item['product_name'].toString(),
              ),
            )
            .toList();
      } catch (_) {}
    }

    return _fallback.variants
        .where((variant) => variant.stockQuantity <= variant.minimumStock)
        .toList();
  }

  Future<void> createProduct({
    required String name,
    required String brandId,
    required String categoryId,
    required String viscosity,
    required String description,
  }) async {
    final client = _client;
    if (client != null) {
      try {
        await client.from('products').insert({
          'brand_id': brandId,
          'category_id': categoryId,
          'name': name,
          'slug': _slugify(name),
          'description': description,
          'short_description': description,
          'viscosity': viscosity,
          'vehicle_type': <String>[],
          'engine_type': <String>[],
          'status': 'active',
          'is_active': true,
        });
        return;
      } catch (_) {}
    }

    _fallback.products.add(
      Product(
        id: 'fallback-${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        priceValue: 0,
        sae: viscosity,
        volume: '-',
        type: '-',
        series: '-',
        description: description,
        imageUrl: null,
        brand: (await getBrands())
                .firstWhere(
                  (item) => item.id == brandId,
                  orElse: () => const BrandInfo(id: '', name: 'Unknown'),
                )
                .name,
        category: (await getCategories())
                .firstWhere(
                  (item) => item.id == categoryId,
                  orElse: () => const CategoryInfo(id: '', name: 'Unknown'),
                )
                .name,
      ),
    );
  }

  Future<void> updateProduct(
    String id, {
    String? name,
    String? description,
    String? viscosity,
    bool? isActive,
  }) async {
    final client = _client;
    if (client != null) {
      try {
        await client
            .from('products')
            .update({
              'name': name,
              'slug': name != null ? _slugify(name) : null,
              'description': description,
              'short_description': description,
              'viscosity': viscosity,
              'is_active': isActive,
            }..removeWhere((key, value) => value == null))
            .eq('id', id);
        return;
      } catch (_) {}
    }

    final index = _fallback.products.indexWhere((product) => product.id == id);
    if (index >= 0) {
      final existing = _fallback.products[index];
      _fallback.products[index] = existing.copyWith(
        name: name ?? existing.name,
        description: description ?? existing.description,
        sae: viscosity ?? existing.sae,
      );
    }
  }

  Future<void> activateDeactivateProduct(String id, bool isActive) async {
    await updateProduct(id, isActive: isActive);
  }

  Future<List<Product>?> _tryGetActiveProductsFromNewSchema() async {
    final client = _client;
    if (client == null) {
      return null;
    }

    try {
      final response = await client.from('products').select('''
id,
name,
description,
viscosity,
product_type,
series,
brands:brand_id(name),
categories:category_id(name),
product_variants!inner(id,price,volume_label),
product_images(image_url,is_primary,sort_order)
''').eq('is_active', true).eq('status', 'active').order('name');

      return (response as List<dynamic>).map(_mapNewProduct).toList();
    } catch (_) {
      return null;
    }
  }

  Future<List<Product>?> _tryGetActiveProductsFromLegacySchema() async {
    final client = _client;
    if (client == null) {
      return null;
    }

    try {
      final response = await client.from('produk').select('''
id_produk,
nama_produk,
harga,
sae,
volume,
tipe,
deskripsi,
gambar,
seri,
kategori:kategori!produk_id_kategori_fkey(nama_kategori),
merk:merk!produk_id_merk_fkey(nama_merk)
''').order('id_produk');

      return (response as List<dynamic>)
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Product _mapNewProduct(dynamic raw) {
    final item = raw as Map<String, dynamic>;
    final variants = (item['product_variants'] as List<dynamic>? ?? const []);
    final primaryVariant =
        variants.isNotEmpty ? variants.first as Map<String, dynamic> : null;
    final images = (item['product_images'] as List<dynamic>? ?? const []);
    final primaryImage = images.cast<Map<String, dynamic>?>().firstWhere(
          (image) => image?['is_primary'] == true,
          orElse: () => images.isNotEmpty ? images.first as Map<String, dynamic> : null,
        );

    return Product(
      id: item['id'].toString(),
      name: (item['name'] ?? '').toString(),
      priceValue: (primaryVariant?['price'] as num?) ?? 0,
      sae: (item['viscosity'] ?? '-').toString(),
      volume: (primaryVariant?['volume_label'] ?? '-').toString(),
      type: (item['product_type'] ?? '-').toString(),
      series: (item['series'] ?? '-').toString(),
      description: (item['description'] ?? 'Detail produk belum tersedia.').toString(),
      imageUrl: primaryImage?['image_url']?.toString(),
      brand: _extractNestedName(item['brands'], 'name') ?? 'Pertamina',
      category: _extractNestedName(item['categories'], 'name') ?? 'Oli',
    );
  }

  String? _extractNestedName(dynamic raw, String field) {
    if (raw is Map<String, dynamic>) {
      return raw[field]?.toString();
    }
    if (raw is List && raw.isNotEmpty && raw.first is Map<String, dynamic>) {
      return (raw.first as Map<String, dynamic>)[field]?.toString();
    }
    return null;
  }

  String _slugify(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
  }
}
