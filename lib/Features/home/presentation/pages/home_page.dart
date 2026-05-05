import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toko_oli/core/models/app_entities.dart';
import 'package:toko_oli/core/presentation/formatters.dart';
import 'package:toko_oli/core/presentation/widgets/premium_ui.dart';
import 'package:toko_oli/core/providers/app_providers.dart';
import 'package:toko_oli/core/theme/app_theme.dart';
import 'package:toko_oli/features/cart/presentation/widgets/add_to_cart_bottom_sheet.dart';
import 'package:toko_oli/features/home/presentation/widgets/produk_card.dart';
import 'package:toko_oli/features/product/domain/product.dart';
import 'package:toko_oli/features/product/presentation/pages/product_detail_page.dart';
import 'package:toko_oli/features/product/presentation/providers/product_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(productsProvider);
    ref.invalidate(activePromosProvider);
    ref.invalidate(homeRecommendationsProvider);
    ref.invalidate(publishedArticlesProvider);
    ref.invalidate(myOrdersProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProducts = ref.watch(productsProvider);
    final asyncPromos = ref.watch(activePromosProvider);
    final asyncRecommendations = ref.watch(homeRecommendationsProvider);
    final asyncArticles = ref.watch(publishedArticlesProvider);
    final asyncOrders = ref.watch(myOrdersProvider);
    final products = asyncProducts.valueOrNull ?? const <Product>[];

    return Scaffold(
      backgroundColor: context.appColors.background,
      body: PremiumPageBackground(
        child: RefreshIndicator(
          onRefresh: () => _refresh(ref),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              const _HomeTopBar(),
              const SizedBox(height: 18),
              _HeroSection(
                productCount: products.length,
                promoCount: asyncPromos.valueOrNull?.length ?? 0,
              ),
              const SizedBox(height: 18),
              _QuickStats(ordersAsync: asyncOrders),
              const SizedBox(height: 18),
              const _CategorySection(),
              const SizedBox(height: 24),
              _PromoSection(promosAsync: asyncPromos),
              const SizedBox(height: 24),
              _FeaturedProductsSection(productsAsync: asyncProducts),
              const SizedBox(height: 24),
              _RecommendationSection(productsAsync: asyncRecommendations),
              const SizedBox(height: 24),
              _TrackingSection(ordersAsync: asyncOrders),
              const SizedBox(height: 24),
              _ArticleSection(articlesAsync: asyncArticles),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeTopBar extends StatelessWidget {
  const _HomeTopBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'OLIMART',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white70,
                  letterSpacing: 1.6,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Engine Care, Simplified',
                style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 6),
              Text(
                'Belanja oli, pantau order, dan cek rekomendasi servis lebih cepat.',
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
          ),
          child: const Icon(Icons.notifications_none_rounded, color: Colors.white),
        ),
      ],
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({
    required this.productCount,
    required this.promoCount,
  });

  final int productCount;
  final int promoCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    return PremiumCard(
      radius: 30,
      backgroundColor: Colors.transparent,
      borderColor: Colors.white.withValues(alpha: 0.12),
      padding: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colors.primary,
              const Color(0xFF1F2937),
              colors.accent,
            ],
          ),
        ),
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const MetricPill(
                  label: 'Premium automotive UI',
                  icon: Icons.auto_awesome_rounded,
                  backgroundColor: Color(0x24FFFFFF),
                  foregroundColor: Colors.white,
                ),
                const Spacer(),
                StatusBadge(
                  label: '$promoCount promo aktif',
                  backgroundColor: Colors.white.withValues(alpha: 0.14),
                  foregroundColor: Colors.white,
                  icon: Icons.local_offer_outlined,
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              'Cari oli yang tepat, tambah ke cart, dan checkout tanpa ribet.',
              style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              'Fokus tampilan baru ini adalah hirarki produk yang lebih jelas, section promo yang lebih bersih, dan akses cepat ke tracking order.',
              style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                StatusBadge(
                  label: '$productCount produk',
                  backgroundColor: Colors.white,
                  foregroundColor: colors.primary,
                  icon: Icons.inventory_2_outlined,
                ),
                const StatusBadge(
                  label: 'Dummy fallback aktif',
                  backgroundColor: Color(0x24FFFFFF),
                  foregroundColor: Colors.white,
                  icon: Icons.cloud_done_outlined,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickStats extends StatelessWidget {
  const _QuickStats({required this.ordersAsync});

  final AsyncValue<List<OrderInfo>> ordersAsync;

  @override
  Widget build(BuildContext context) {
    final orders = ordersAsync.valueOrNull ?? const <OrderInfo>[];
    final recentOrder = orders.isEmpty ? null : orders.first;
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.22,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        StatCard(
          label: 'Last Order',
          value: recentOrder?.orderNumber ?? 'Belum ada',
          subtitle: recentOrder == null
              ? 'Mulai dari katalog utama'
              : titleCaseStatus(recentOrder.orderStatus),
          icon: Icons.receipt_long_outlined,
        ),
        StatCard(
          label: 'Order Value',
          value: recentOrder == null ? formatRupiah(0) : formatRupiah(recentOrder.grandTotal),
          subtitle: recentOrder == null
              ? 'Siap checkout'
              : formatShortDate(recentOrder.createdAt),
          icon: Icons.payments_outlined,
          highlightColor: context.appColors.gold,
        ),
      ],
    );
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    const categories = <(String, String, IconData)>[
      ('Oli Motor', 'Scooter dan sport harian', Icons.two_wheeler_rounded),
      ('Oli Mobil', 'Mesin bensin modern', Icons.directions_car_filled_rounded),
      ('Diesel', 'Heavy duty dan niaga', Icons.local_shipping_outlined),
      ('Promo Servis', 'Bundling dan voucher', Icons.local_offer_outlined),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Explore by Need',
          subtitle: 'Shortcut cepat ke kategori dan kebutuhan servis paling sering.',
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {
            final item = categories[index];
            final isAccent = index.isEven;
            return PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: (isAccent ? colors.accent : colors.gold).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      item.$3,
                      color: isAccent ? colors.accent : colors.gold,
                    ),
                  ),
                  const Spacer(),
                  Text(item.$1, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(item.$2, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _PromoSection extends StatelessWidget {
  const _PromoSection({required this.promosAsync});

  final AsyncValue<List<PromoInfo>> promosAsync;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Promo Highlights',
          subtitle: 'Voucher dan campaign yang paling relevan untuk checkout berikutnya.',
        ),
        const SizedBox(height: 12),
        promosAsync.when(
          data: (promos) {
            if (promos.isEmpty) {
              return const EmptyStateCard(
                title: 'Belum ada promo aktif',
                message: 'Promo baru akan tampil di sini saat campaign berjalan.',
                icon: Icons.local_offer_outlined,
              );
            }
            return Column(
              children: promos
                  .take(2)
                  .map(
                    (promo) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: PremiumCard(
                        child: Row(
                          children: [
                            const StatusBadge(
                              label: 'Active',
                              backgroundColor: Color(0xFFFFF1D6),
                              foregroundColor: Color(0xFF92400E),
                              icon: Icons.bolt_rounded,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(promo.title, style: Theme.of(context).textTheme.titleMedium),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${promo.code} • Diskon ${promo.discountValue.toStringAsFixed(0)}%',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            );
          },
          loading: () => const LoadingCard(lines: 3),
          error: (error, _) => EmptyStateCard(
            title: 'Promo belum tersedia',
            message: error.toString(),
            icon: Icons.error_outline_rounded,
          ),
        ),
      ],
    );
  }
}

class _FeaturedProductsSection extends StatelessWidget {
  const _FeaturedProductsSection({required this.productsAsync});

  final AsyncValue<List<Product>> productsAsync;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Technician Picks',
          subtitle: 'Kurasi produk dengan visual yang lebih fokus ke brand, SAE, dan CTA.',
          action: AppSectionButton(label: 'Lihat semua', onTap: () {}),
        ),
        const SizedBox(height: 14),
        productsAsync.when(
          data: (products) {
            if (products.isEmpty) {
              return const EmptyStateCard(
                title: 'Belum ada produk unggulan',
                message: 'Tambahkan produk aktif agar section ini terisi.',
                icon: Icons.inventory_outlined,
              );
            }
            final highlights = products.take(6).toList();
            return SizedBox(
              height: 388,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: highlights.length,
                separatorBuilder: (_, _) => const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  final product = highlights[index];
                  return SizedBox(
                    width: 270,
                    child: ProductCard(
                      product: product,
                      layout: ProductCardLayout.featured,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailPage(product: product),
                        ),
                      ),
                      onPrimaryAction: () => AddToCartBottomSheet.show(context, product),
                    ),
                  );
                },
              ),
            );
          },
          loading: () => SizedBox(
            height: 210,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) =>
                  const SizedBox(width: 270, child: LoadingCard(lines: 5)),
              separatorBuilder: (context, index) => const SizedBox(width: 14),
              itemCount: 2,
            ),
          ),
          error: (error, _) => EmptyStateCard(
            title: 'Katalog belum tersambung',
            message: error.toString(),
            icon: Icons.cloud_off_rounded,
          ),
        ),
      ],
    );
  }
}

class _RecommendationSection extends StatelessWidget {
  const _RecommendationSection({required this.productsAsync});

  final AsyncValue<List<Product>> productsAsync;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Oil Recommendation Flow',
          subtitle: 'Rekomendasi diambil dari profil kendaraan saat tersedia, dengan fallback dummy yang tetap aman.',
        ),
        const SizedBox(height: 12),
        productsAsync.when(
          data: (products) => PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: const [
                    StatusBadge(label: '1. Pilih kendaraan', icon: Icons.directions_car_outlined),
                    StatusBadge(label: '2. Cocokkan viskositas', icon: Icons.opacity_outlined),
                    StatusBadge(label: '3. Tambah ke cart', icon: Icons.shopping_cart_outlined),
                  ],
                ),
                const SizedBox(height: 16),
                if (products.isEmpty)
                  const Text('Belum ada rekomendasi saat ini.')
                else
                  ...products.take(3).map(
                        (product) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: context.appColors.surfaceMuted,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(Icons.tune_rounded, color: context.appColors.accent),
                            ),
                            title: Text(product.name),
                            subtitle: Text('${product.brand} • ${product.sae}'),
                            trailing: Text(formatRupiah(product.priceValue)),
                          ),
                        ),
                      ),
              ],
            ),
          ),
          loading: () => const LoadingCard(lines: 4),
          error: (error, _) => EmptyStateCard(
            title: 'Rekomendasi belum siap',
            message: error.toString(),
            icon: Icons.error_outline_rounded,
          ),
        ),
      ],
    );
  }
}

class _TrackingSection extends StatelessWidget {
  const _TrackingSection({required this.ordersAsync});

  final AsyncValue<List<OrderInfo>> ordersAsync;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Order Tracking Timeline',
          subtitle: 'Progress order terbaru ditampilkan dengan alur yang lebih mudah dipindai.',
        ),
        const SizedBox(height: 12),
        ordersAsync.when(
          data: (orders) {
            if (orders.isEmpty) {
              return const EmptyStateCard(
                title: 'Belum ada order aktif',
                message: 'Setelah checkout, timeline order akan tampil di sini.',
                icon: Icons.timeline_outlined,
              );
            }
            final order = orders.first;
            final steps = _timelineSteps(order);
            return PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order.orderNumber, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    '${titleCaseStatus(order.orderStatus)} • ${formatShortDate(order.createdAt)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  for (var index = 0; index < steps.length; index++)
                    TimelineStep(
                      title: steps[index].$1,
                      subtitle: steps[index].$2,
                      isActive: index <= steps.indexWhere((step) => step.$3),
                      isLast: index == steps.length - 1,
                    ),
                ],
              ),
            );
          },
          loading: () => const LoadingCard(lines: 4),
          error: (error, _) => EmptyStateCard(
            title: 'Timeline belum tersedia',
            message: error.toString(),
            icon: Icons.error_outline_rounded,
          ),
        ),
      ],
    );
  }

  List<(String, String, bool)> _timelineSteps(OrderInfo order) {
    final status = order.orderStatus;
    return <(String, String, bool)>[
      ('Order dibuat', 'Pesanan masuk dan menunggu verifikasi.', true),
      ('Diproses', 'Admin menyiapkan item dan stok.', status != 'pending'),
      ('Dikirim', 'Courier mulai mengantarkan pesanan.', status == 'shipped' || status == 'completed'),
      ('Selesai', 'Pesanan diterima oleh pelanggan.', status == 'completed'),
    ];
  }
}

class _ArticleSection extends StatelessWidget {
  const _ArticleSection({required this.articlesAsync});

  final AsyncValue<List<ArticleInfo>> articlesAsync;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Article Picks',
          subtitle: 'Konten edukasi untuk memperkuat UX setelah browsing produk.',
        ),
        const SizedBox(height: 12),
        articlesAsync.when(
          data: (articles) {
            if (articles.isEmpty) {
              return const EmptyStateCard(
                title: 'Belum ada artikel',
                message: 'Artikel terbit akan muncul di halaman ini.',
                icon: Icons.article_outlined,
              );
            }
            return Column(
              children: articles
                  .take(3)
                  .map(
                    (article) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: PremiumCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const StatusBadge(
                              label: 'Published',
                              icon: Icons.auto_stories_outlined,
                            ),
                            const SizedBox(height: 12),
                            Text(article.title, style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            Text(
                              article.content,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            );
          },
          loading: () => const LoadingCard(lines: 4),
          error: (error, _) => EmptyStateCard(
            title: 'Artikel belum tersedia',
            message: error.toString(),
            icon: Icons.error_outline_rounded,
          ),
        ),
      ],
    );
  }
}
