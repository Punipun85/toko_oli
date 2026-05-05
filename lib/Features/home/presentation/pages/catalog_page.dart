import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toko_oli/core/presentation/widgets/premium_ui.dart';
import 'package:toko_oli/core/providers/app_providers.dart';
import 'package:toko_oli/core/theme/app_theme.dart';
import 'package:toko_oli/features/cart/presentation/widgets/add_to_cart_bottom_sheet.dart';
import 'package:toko_oli/features/home/presentation/widgets/produk_card.dart';
import 'package:toko_oli/features/product/domain/product.dart';
import 'package:toko_oli/features/product/presentation/pages/product_detail_page.dart';
import 'package:toko_oli/features/product/presentation/providers/product_provider.dart';

class CatalogPage extends ConsumerStatefulWidget {
  const CatalogPage({super.key});

  @override
  ConsumerState<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends ConsumerState<CatalogPage> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    ref.invalidate(productsProvider);
    ref.invalidate(categoriesProvider);
  }

  @override
  Widget build(BuildContext context) {
    final asyncProducts = ref.watch(productsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final products = asyncProducts.valueOrNull ?? const <Product>[];
    final categories = categoriesAsync.valueOrNull ?? const [];
    final filtered = _applyFilters(products);
    final width = MediaQuery.sizeOf(context).width;
    final crossAxisCount = width >= 1100 ? 4 : width >= 760 ? 3 : width >= 560 ? 2 : 1;
    final mainAxisExtent = crossAxisCount == 1 ? 430.0 : 408.0;

    return Scaffold(
      backgroundColor: context.appColors.background,
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 228,
              backgroundColor: context.appColors.primary,
              foregroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  padding: const EdgeInsets.fromLTRB(16, 96, 16, 24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        context.appColors.primary,
                        const Color(0xFF1F2937),
                        context.appColors.accent,
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const MetricPill(
                        label: 'Catalog grid refresh',
                        icon: Icons.grid_view_rounded,
                        backgroundColor: Color(0x24FFFFFF),
                        foregroundColor: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Browse by spec, not by clutter',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Grid dibuat lebih seimbang untuk layar kecil, dengan filter lokal yang tetap aman terhadap fallback data.',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Cari brand, SAE, kategori, atau nama produk',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: _searchController.text.isEmpty
                            ? null
                            : IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {});
                                },
                                icon: const Icon(Icons.close_rounded),
                              ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _FilterChip(
                            label: 'All',
                            selected: _selectedCategory == 'All',
                            onTap: () => setState(() => _selectedCategory = 'All'),
                          ),
                          ...categories.map(
                            (category) => Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: _FilterChip(
                                label: category.name,
                                selected: _selectedCategory == category.name,
                                onTap: () => setState(() => _selectedCategory = category.name),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    PremiumCard(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Catalog Snapshot',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${filtered.length} produk cocok dengan filter aktif.',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          StatusBadge(
                            label: '${filtered.length} items',
                            icon: Icons.inventory_2_outlined,
                            backgroundColor: context.appColors.surfaceMuted,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (asyncProducts.isLoading)
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => const LoadingCard(lines: 5),
                    childCount: crossAxisCount == 1 ? 2 : 4,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    mainAxisExtent: 220,
                  ),
                ),
              )
            else if (asyncProducts.hasError)
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverToBoxAdapter(
                  child: EmptyStateCard(
                    title: 'Gagal memuat katalog',
                    message: asyncProducts.error.toString(),
                    icon: Icons.cloud_off_rounded,
                  ),
                ),
              )
            else if (filtered.isEmpty)
              const SliverPadding(
                padding: EdgeInsets.all(16),
                sliver: SliverToBoxAdapter(
                  child: EmptyStateCard(
                    title: 'Produk tidak ditemukan',
                    message: 'Coba ubah kata kunci atau kategori yang dipilih.',
                    icon: Icons.search_off_rounded,
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    mainAxisExtent: mainAxisExtent,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = filtered[index];
                      return ProductCard(
                        product: product,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailPage(product: product),
                          ),
                        ),
                        onPrimaryAction: () => AddToCartBottomSheet.show(context, product),
                      );
                    },
                    childCount: filtered.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Product> _applyFilters(List<Product> products) {
    final query = _searchController.text.trim().toLowerCase();
    return products.where((product) {
      final matchesCategory =
          _selectedCategory == 'All' || product.category == _selectedCategory;
      final haystack = [
        product.name,
        product.brand,
        product.category,
        product.sae,
        product.series,
      ].join(' ').toLowerCase();
      final matchesQuery = query.isEmpty || haystack.contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? colors.primary : colors.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: selected ? colors.primary : colors.outline),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: selected ? Colors.white : colors.primary,
              ),
        ),
      ),
    );
  }
}
