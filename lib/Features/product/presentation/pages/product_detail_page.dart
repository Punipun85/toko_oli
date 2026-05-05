import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toko_oli/core/presentation/formatters.dart';
import 'package:toko_oli/core/presentation/widgets/premium_ui.dart';
import 'package:toko_oli/core/providers/app_providers.dart';
import 'package:toko_oli/core/theme/app_theme.dart';
import 'package:toko_oli/features/cart/presentation/widgets/add_to_cart_bottom_sheet.dart';
import 'package:toko_oli/features/home/presentation/widgets/produk_card.dart';
import 'package:toko_oli/features/product/domain/product.dart';

class ProductDetailPage extends ConsumerWidget {
  const ProductDetailPage({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final variantsAsync = ref.watch(_productVariantsProvider(product.id));
    final reviewsAsync = ref.watch(_productReviewsProvider(product.id));
    final articlesAsync = ref.watch(publishedArticlesProvider);

    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        title: const Text('Product Detail'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined)),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.bookmark_border_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _HeroImage(product: product),
          const SizedBox(height: 18),
          _ProductHeadline(product: product),
          const SizedBox(height: 18),
          _ProductSummary(product: product),
          const SizedBox(height: 20),
          _VariantSection(variantsAsync: variantsAsync),
          const SizedBox(height: 20),
          _SpecSection(product: product),
          const SizedBox(height: 20),
          const _WhyItWorksSection(),
          const SizedBox(height: 20),
          _ReviewSection(reviewsAsync: reviewsAsync),
          const SizedBox(height: 20),
          _ArticleSupportSection(articlesAsync: articlesAsync),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => AddToCartBottomSheet.show(context, product),
                child: const Text('Add to cart'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${product.name} siap untuk checkout.')),
                  );
                },
                child: const Text('Buy now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final _productVariantsProvider = FutureProvider.family((ref, String productId) {
  return ref.watch(productRepositoryProvider).getProductVariants(productId);
});

final _productReviewsProvider = FutureProvider.family((ref, String productId) {
  return ref.watch(reviewRepositoryProvider).getProductReviews(productId);
});

class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return PremiumCard(
      padding: EdgeInsets.zero,
      radius: 30,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colors.surfaceMuted, const Color(0xFFE4ECFF)],
            ),
          ),
          child: ProductImagePanel(product: product, height: 290),
        ),
      ),
    );
  }
}

class _ProductHeadline extends StatelessWidget {
  const _ProductHeadline({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            MetricPill(label: product.brand.toUpperCase(), icon: Icons.shield_outlined),
            MetricPill(label: product.category, icon: Icons.category_outlined),
            StatusBadge(
              label: '4.9 rating',
              icon: Icons.star_rounded,
              backgroundColor: colors.gold.withValues(alpha: 0.18),
              foregroundColor: colors.primary,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(product.name, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(product.description, style: theme.textTheme.bodyLarge),
      ],
    );
  }
}

class _ProductSummary extends StatelessWidget {
  const _ProductSummary({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    return PremiumCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.hasPrice ? 'Current price' : 'Price status',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  product.price,
                  style: theme.textTheme.headlineSmall?.copyWith(color: colors.accent),
                ),
                const SizedBox(height: 8),
                Text(
                  'UI checkout sekarang dibuat lebih aman untuk layar kecil dan fallback data.',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                MetricPill(
                  label: product.volume,
                  icon: Icons.inventory_2_outlined,
                  backgroundColor: colors.primary,
                  foregroundColor: Colors.white,
                ),
                const SizedBox(height: 10),
                StatusBadge(
                  label: product.sae,
                  icon: Icons.opacity_rounded,
                  backgroundColor: colors.surfaceMuted,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VariantSection extends StatelessWidget {
  const _VariantSection({required this.variantsAsync});

  final AsyncValue<List> variantsAsync;

  @override
  Widget build(BuildContext context) {
    return variantsAsync.when(
      data: (variants) => PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'Variant Management View',
              subtitle: 'Volume, harga, dan stok ditampilkan lebih ringkas untuk customer.',
            ),
            const SizedBox(height: 12),
            if (variants.isEmpty)
              const Text('Belum ada varian aktif.')
            else
              ...variants.map(
                    (variant) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Text(
                            variant.volumeLabel.isEmpty ? variant.name : variant.volumeLabel,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          StatusBadge(label: 'Stock ${variant.stockQuantity}'),
                          Text(formatRupiah(variant.price)),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
      loading: () => const LoadingCard(lines: 3),
      error: (error, _) => EmptyStateCard(
        title: 'Varian belum tersedia',
        message: error.toString(),
        icon: Icons.error_outline_rounded,
      ),
    );
  }
}

class _SpecSection extends StatelessWidget {
  const _SpecSection({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final rows = [
      ('SAE', product.sae),
      ('Volume', product.volume),
      ('Series', product.series),
      ('Category', product.category),
      ('Type', product.type),
    ];

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Technical Specs',
            subtitle: 'Spesifikasi penting yang biasa dicek sebelum servis.',
          ),
          const SizedBox(height: 12),
          ...rows.map(
            (row) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(child: Text(row.$1, style: Theme.of(context).textTheme.bodyMedium)),
                  Expanded(
                    child: Text(
                      row.$2,
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: colors.primary,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WhyItWorksSection extends StatelessWidget {
  const _WhyItWorksSection();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    const bullets = [
      'Menjaga mesin tetap bersih dari endapan berlebih.',
      'Memberi performa stabil untuk suhu kerja tinggi dan penggunaan harian.',
      'Layout sekarang menonjolkan spesifikasi, variant, dan CTA checkout.',
    ];
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Why It Works',
            subtitle: 'Disusun ulang untuk membantu keputusan beli lebih cepat.',
          ),
          const SizedBox(height: 12),
          ...bullets.map(
            (text) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Icon(Icons.check_circle_rounded, color: colors.gold, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyLarge)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewSection extends StatelessWidget {
  const _ReviewSection({required this.reviewsAsync});

  final AsyncValue<List> reviewsAsync;

  @override
  Widget build(BuildContext context) {
    return reviewsAsync.when(
      data: (reviews) => PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'Customer Reviews',
              subtitle: 'Area review dibuat lebih bersih, tetap aman untuk fallback data.',
            ),
            const SizedBox(height: 12),
            if (reviews.isEmpty)
              const Text('Belum ada review untuk produk ini.')
            else
              ...reviews.take(2).map(
                    (review) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StatusBadge(label: 'Rating ${review.rating}/5', icon: Icons.star_rounded),
                          const SizedBox(height: 8),
                          Text(review.body, style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
      loading: () => const LoadingCard(lines: 3),
      error: (error, _) => EmptyStateCard(
        title: 'Review belum tersedia',
        message: error.toString(),
        icon: Icons.error_outline_rounded,
      ),
    );
  }
}

class _ArticleSupportSection extends StatelessWidget {
  const _ArticleSupportSection({required this.articlesAsync});

  final AsyncValue<List> articlesAsync;

  @override
  Widget build(BuildContext context) {
    return articlesAsync.when(
      data: (articles) => PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'Related Articles',
              subtitle: 'Konten edukasi untuk memperkaya product detail page.',
            ),
            const SizedBox(height: 12),
            if (articles.isEmpty)
              const Text('Belum ada artikel terkait.')
            else
              ...articles.take(2).map(
                    (article) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.article_outlined),
                      title: Text(article.title),
                      subtitle: Text(
                        article.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
          ],
        ),
      ),
      loading: () => const LoadingCard(lines: 3),
      error: (error, _) => EmptyStateCard(
        title: 'Artikel belum tersedia',
        message: error.toString(),
        icon: Icons.error_outline_rounded,
      ),
    );
  }
}
