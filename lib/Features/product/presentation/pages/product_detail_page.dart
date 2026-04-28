import 'package:flutter/material.dart';
import 'package:toko_oli/Features/model/product_model.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.bookmark_border_rounded)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Container(
            height: 260,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                colors: [Color(0xFF313539), Color(0xFF101417)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: const Color(0xFF5A4136)),
            ),
            child: product.imageUrl == null || product.imageUrl!.isEmpty
                ? Center(
                    child: Text(
                      '${product.sae}\n${product.volume}',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: const Color(0xFFFFB693),
                      ),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Image.network(
                      product.imageUrl!,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Center(
                        child: Text(
                          '${product.sae}\n${product.volume}',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: const Color(0xFFFFB693),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF262A2E),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  product.brand.toUpperCase(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFFFFB693),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(Icons.star_rounded, color: Color(0xFFFFB693), size: 18),
              const SizedBox(width: 4),
              Text('4.9', style: theme.textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 14),
          Text(product.name, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(product.description, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 18),
          Text(
            product.price,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: const Color(0xFFFFB693),
            ),
          ),
          const SizedBox(height: 24),
          Text('Spesifikasi Teknis', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          _SpecCard(
            rows: [
              ('Tingkat kekentalan', product.sae),
              ('Volume', product.volume),
              ('Seri', product.series),
              ('Kategori', product.category),
              ('Tipe', product.type),
            ],
          ),
          const SizedBox(height: 20),
          Text('Keunggulan', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          const _FeatureBullet(text: 'Menjaga kebersihan mesin dari endapan.'),
          const _FeatureBullet(text: 'Meningkatkan kestabilan performa pada suhu tinggi.'),
          const _FeatureBullet(text: 'Cocok untuk kendaraan harian dan perjalanan jauh.'),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                child: const Text('Tambah ke keranjang'),
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
                child: const Text('Beli sekarang'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpecCard extends StatelessWidget {
  const _SpecCard({required this.rows});

  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2024),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF313539)),
      ),
      child: Column(
        children: rows
            .map(
              (row) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        row.$1,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        row.$2,
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _FeatureBullet extends StatelessWidget {
  const _FeatureBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(Icons.check_circle_rounded, color: Color(0xFFFFB693), size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}
