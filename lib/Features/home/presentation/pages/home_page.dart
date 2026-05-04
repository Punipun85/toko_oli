import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toko_oli/features/product/domain/product.dart';
import 'package:toko_oli/features/home/presentation/widgets/produk_card.dart';
import 'package:toko_oli/features/product/presentation/pages/product_detail_page.dart';
import 'package:toko_oli/features/product/presentation/providers/product_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  Future<void> _refreshProducts(WidgetRef ref) {
    return ref.refresh(productsProvider.future);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final asyncProducts = ref.watch(productsProvider);
    final products = asyncProducts.valueOrNull ?? const <Product>[];
    final recommendationHeight = MediaQuery.sizeOf(context).width < 700
        ? 412.0
        : 388.0;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GARAGE PREMIUM',
              style: theme.textTheme.labelLarge?.copyWith(
                color: const Color(0xFFFFB693),
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 4),
            Text('Surakarta, Jawa Tengah', style: theme.textTheme.bodyMedium),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.tune_rounded)),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          return RefreshIndicator(
            onRefresh: () => _refreshProducts(ref),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Cari merk oli, SAE, atau jenis kendaraan',
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                ),
                const SizedBox(height: 20),
                _HeroPromoCard(productCount: products.length),
                if (asyncProducts.hasError) ...[
                  const SizedBox(height: 16),
                  _ErrorCard(
                    onRetry: () {
                      ref.invalidate(productsProvider);
                    },
                  ),
                ],
                const SizedBox(height: 24),
                Text('Vehicle Selector', style: theme.textTheme.titleLarge),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: const [
                    Chip(label: Text('Honda Vario 150')),
                    Chip(label: Text('Toyota Avanza')),
                    Chip(label: Text('Yamaha NMAX')),
                    Chip(label: Text('Manual / CVT')),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Text('Kategori Utama', style: theme.textTheme.titleLarge),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Lihat semua'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const _CategoryStrip(),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Rekomendasi Teknisi',
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        color: const Color(0xFF262A2E),
                      ),
                      child: Text(
                        '${products.length} produk',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFFFFB693),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: recommendationHeight,
                  child: asyncProducts.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : products.isEmpty
                      ? const Center(
                          child: Text(
                            'Belum ada produk yang tersedia di database.',
                          ),
                        )
                      : ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: products.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 14),
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return _ProductHighlightCard(product: product);
                          },
                        ),
                ),
                const SizedBox(height: 24),
                Text('Kenapa pilih kami?', style: theme.textTheme.titleLarge),
                const SizedBox(height: 12),
                const _TrustRow(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HeroPromoCard extends StatelessWidget {
  const _HeroPromoCard({required this.productCount});

  final int productCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B00), Color(0xFF7A3000)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performa maksimal untuk mesin harian Anda',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '$productCount oli pilihan, filter teknis yang jelas, dan gaya belanja ala bengkel premium.',
            style: theme.textTheme.bodyLarge?.copyWith(color: Colors.black87),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: const Color(0xFFFFB693),
                  ),
                  child: const Text('Lihat katalog'),
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.speed_rounded, color: Colors.black, size: 34),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryStrip extends StatelessWidget {
  const _CategoryStrip();

  @override
  Widget build(BuildContext context) {
    final categories = const [
      (Icons.two_wheeler_rounded, 'Oli Motor'),
      (Icons.directions_car_filled_rounded, 'Oli Mobil'),
      (Icons.settings_rounded, 'Transmisi'),
      (Icons.opacity_rounded, 'Sintetis'),
    ];

    return Row(
      children: categories
          .map(
            (category) => Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C2024),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFF5A4136)),
                ),
                child: Column(
                  children: [
                    Icon(category.$1, color: const Color(0xFFFFB693)),
                    const SizedBox(height: 8),
                    Text(
                      category.$2,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFFE0E3E8),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _ProductHighlightCard extends StatelessWidget {
  const _ProductHighlightCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: ProductCard(
        product: product,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailPage(product: product),
            ),
          );
        },
        layout: ProductCardLayout.featured,
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2B1E1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFF6B00)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Koneksi Supabase gagal dibaca.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Coba muat ulang data untuk mengambil katalog terbaru dari database.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: onRetry, child: const Text('Coba lagi')),
        ],
      ),
    );
  }
}

class _TrustRow extends StatelessWidget {
  const _TrustRow();

  @override
  Widget build(BuildContext context) {
    const items = [
      ('Produk Asli', Icons.verified_rounded),
      ('Teknisi Kurasi', Icons.build_circle_rounded),
      ('Kirim Cepat', Icons.local_shipping_rounded),
    ];

    return Row(
      children: items
          .map(
            (item) => Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C2024),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    Icon(item.$2, color: const Color(0xFFFFB693)),
                    const SizedBox(height: 10),
                    Text(
                      item.$1,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFFE0E3E8),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
