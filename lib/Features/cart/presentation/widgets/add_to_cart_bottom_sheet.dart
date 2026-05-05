import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toko_oli/core/theme/app_theme.dart';
import 'package:toko_oli/features/cart/presentation/controllers/cart_controller.dart';
import 'package:toko_oli/features/product/domain/product.dart';

class AddToCartBottomSheet extends ConsumerStatefulWidget {
  const AddToCartBottomSheet({super.key, required this.product});

  final Product product;

  static void show(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddToCartBottomSheet(product: product),
      ),
    );
  }

  @override
  ConsumerState<AddToCartBottomSheet> createState() => _AddToCartBottomSheetState();
}

class _AddToCartBottomSheetState extends ConsumerState<AddToCartBottomSheet> {
  String _selectedUnit = 'pcs';
  final _pcsPerDosController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');

  @override
  void dispose() {
    _pcsPerDosController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Tambah ke Keranjang',
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [colors.surfaceMuted, const Color(0xFFE5EDFF)],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      widget.product.sae,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: colors.accent,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name,
                        style: theme.textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.product.price,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colors.accent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Pilih Satuan', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _UnitSelector(
                    label: 'Pcs',
                    isSelected: _selectedUnit == 'pcs',
                    onTap: () => setState(() => _selectedUnit = 'pcs'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _UnitSelector(
                    label: 'Dos',
                    isSelected: _selectedUnit == 'dos',
                    onTap: () => setState(() => _selectedUnit = 'dos'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              _selectedUnit == 'pcs' ? 'Jumlah Pcs' : 'Jumlah Dos',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: _selectedUnit == 'pcs' ? 'Contoh: 2 pcs' : 'Contoh: 3 dos',
                prefixIcon: const Icon(Icons.numbers_rounded),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _selectedUnit == 'pcs'
                  ? 'Customer bisa menentukan berapa pcs yang ingin dibeli.'
                  : 'Customer bisa menentukan berapa dos yang ingin dibeli.',
              style: theme.textTheme.bodySmall,
            ),
            if (_selectedUnit == 'dos') ...[
              const SizedBox(height: 20),
              Text('Isi per Dos (Pcs)', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              TextField(
                controller: _pcsPerDosController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  hintText: 'Contoh: 24',
                  prefixIcon: Icon(Icons.inventory_2_outlined),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Masukkan jumlah pcs di dalam 1 dos untuk kalkulasi harga.',
                style: theme.textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  final messenger = ScaffoldMessenger.of(context);
                  final quantity = int.tryParse(_quantityController.text) ?? 0;
                  if (quantity <= 0) {
                    messenger.showSnackBar(
                      const SnackBar(content: Text('Masukkan jumlah beli yang valid.')),
                    );
                    return;
                  }

                  int? pcsPerDos;
                  if (_selectedUnit == 'dos') {
                    pcsPerDos = int.tryParse(_pcsPerDosController.text);
                    if (pcsPerDos == null || pcsPerDos <= 0) {
                      messenger.showSnackBar(
                        const SnackBar(
                          content: Text('Masukkan isi per dos yang valid.'),
                        ),
                      );
                      return;
                    }
                  }

                  await ref.read(cartProvider.notifier).addProduct(
                        widget.product,
                        unit: _selectedUnit,
                        quantity: quantity,
                        pcsPerDos: pcsPerDos,
                      );

                  if (!mounted) {
                    return;
                  }

                  navigator.pop();
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        '${widget.product.name} ditambahkan: $quantity ${_selectedUnit == 'pcs' ? 'pcs' : 'dos'}.',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.shopping_cart_rounded),
                label: const Text('Masukkan Keranjang'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UnitSelector extends StatelessWidget {
  const _UnitSelector({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? colors.accent.withValues(alpha: 0.08) : colors.surfaceMuted,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? colors.accent : colors.outline,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isSelected ? colors.accent : colors.primary,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                ),
          ),
        ),
      ),
    );
  }
}
