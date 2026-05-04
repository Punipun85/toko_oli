import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toko_oli/features/product/domain/product.dart';
import 'package:toko_oli/features/home/presentation/widgets/produk_card.dart';
import 'package:toko_oli/features/product/presentation/pages/product_detail_page.dart';
import 'package:toko_oli/features/product/presentation/providers/product_provider.dart';
import 'package:toko_oli/features/cart/presentation/controllers/cart_controller.dart';

import 'package:toko_oli/features/cart/presentation/widgets/add_to_cart_bottom_sheet.dart';

class CatalogPage extends ConsumerWidget {
  const CatalogPage({super.key});

  Future<void> _refreshProducts(WidgetRef ref) {
    return ref.refresh(productsProvider.future);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final asyncProducts = ref.watch(productsProvider);
    final products = asyncProducts.valueOrNull ?? const <Product>[];
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isPhone = screenWidth < 560;
    final isTablet = screenWidth >= 560 && screenWidth < 960;
    final horizontalPadding = isPhone ? 12.0 : 16.0;
    final crossAxisCount = isPhone ? 1 : isTablet ? 2 : 3;
    final gridSpacing = isPhone ? 12.0 : 14.0;
    final gridItemExtent = isPhone
        ? 356.0
        : isTablet
        ? 348.0
        : 334.0;

    return Scaffold(
      body: RefreshIndicator.adaptive(
        onRefresh: () => _refreshProducts(ref),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              title: const Text('Katalog Produk'),
              floating: true,
              snap: true,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_list_rounded),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  8,
                  horizontalPadding,
                  12,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Cari SAE, brand, atau kebutuhan mesin',
                          prefixIcon: Icon(Icons.search_rounded),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C2024),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.tune_rounded,
                        color: Color(0xFFFFB693),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 42,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  scrollDirection: Axis.horizontal,
                  children: const [
                    Chip(label: Text('5W-30')),
                    SizedBox(width: 8),
                    Chip(label: Text('10W-40')),
                    SizedBox(width: 8),
                    Chip(label: Text('Mobil')),
                    SizedBox(width: 8),
                    Chip(label: Text('Motor')),
                    SizedBox(width: 8),
                    Chip(label: Text('Sintetis')),
                  ],
                ),
              ),
            ),
            if (asyncProducts.hasError)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    12,
                    horizontalPadding,
                    0,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Gagal memuat produk dari Supabase.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.red[200],
                      ),
                    ),
                  ),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            if (asyncProducts.isLoading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (products.isEmpty)
              const SliverFillRemaining(
                child: Center(child: Text('Produk belum tersedia.')),
              )
            else
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  0,
                  horizontalPadding,
                  24,
                ),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: gridSpacing,
                    mainAxisSpacing: gridSpacing,
                    mainAxisExtent: gridItemExtent,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = products[index];

                      return ProductCard(
                        product: product,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailPage(product: product),
                            ),
                          );
                        },
                        primaryActionLabel: 'Tambah ke keranjang',
                        onPrimaryAction: () {
                          AddToCartBottomSheet.show(context, product);
                        },
                      );
                    },
                    childCount: products.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
