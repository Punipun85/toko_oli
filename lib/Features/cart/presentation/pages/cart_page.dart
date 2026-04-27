import 'package:flutter/material.dart';
import 'package:toko_oli/Features/model/product_model.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = Product.sampleData.take(2).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang Belanja')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...items.map(
            (product) => Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1C2024),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF313539)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 74,
                    height: 74,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF313539), Color(0xFF181C20)],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        product.sae,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: const Color(0xFFFFB693),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.name, style: theme.textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Text(product.brand, style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 8),
                        Text(
                          product.price,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: const Color(0xFFFFB693),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF262A2E),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text('1x', style: theme.textTheme.labelLarge),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF1C2024),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                _SummaryRow(label: 'Subtotal', value: 'Rp 278000'),
                _SummaryRow(label: 'Biaya layanan', value: 'Rp 12000'),
                _SummaryRow(label: 'Estimasi kirim', value: 'Rp 18000'),
                const Divider(height: 28),
                _SummaryRow(
                  label: 'Total',
                  value: 'Rp 308000',
                  valueColor: const Color(0xFFFFB693),
                  isEmphasized: true,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Lanjut ke checkout'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isEmphasized = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool isEmphasized;

  @override
  Widget build(BuildContext context) {
    final textStyle = isEmphasized
        ? Theme.of(context).textTheme.titleMedium
        : Theme.of(context).textTheme.bodyLarge;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(label, style: textStyle),
          const Spacer(),
          Text(
            value,
            style: textStyle?.copyWith(color: valueColor),
          ),
        ],
      ),
    );
  }
}
