import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toko_oli/core/models/app_entities.dart';
import 'package:toko_oli/core/presentation/formatters.dart';
import 'package:toko_oli/core/presentation/widgets/premium_ui.dart';
import 'package:toko_oli/core/providers/app_providers.dart';
import 'package:toko_oli/core/theme/app_theme.dart';
import 'package:toko_oli/features/auth/data/auth_repository.dart';
import 'package:toko_oli/features/cart/domain/cart_item.dart';
import 'package:toko_oli/features/cart/presentation/controllers/cart_controller.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final addressesAsync = ref.watch(myAddressesProvider);
    final promosAsync = ref.watch(activePromosProvider);
    final subtotal = cartNotifier.totalPrice.toDouble();
    final serviceFee = items.isEmpty ? 0.0 : 12000.0;
    final shippingFee = items.isEmpty ? 0.0 : 18000.0;
    final total = subtotal + serviceFee + shippingFee;

    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(title: const Text('Cart Overview')),
      body: items.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(16),
              child: EmptyStateCard(
                title: 'Keranjang masih kosong',
                message: 'Produk yang Anda pilih akan muncul di sini sebelum checkout.',
                icon: Icons.shopping_cart_outlined,
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              children: [
                SectionHeader(
                  title: 'Checkout Flow',
                  subtitle: '${items.length} item aktif siap diproses.',
                  action: StatusBadge(
                    label: 'Safe checkout',
                    icon: Icons.lock_outline_rounded,
                    backgroundColor: context.appColors.gold.withValues(alpha: 0.14),
                    foregroundColor: context.appColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                PremiumCard(
                  child: Column(
                    children: items
                        .map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _CartItemCard(item: item),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 16),
                _CheckoutTimelineCard(items: items),
                const SizedBox(height: 16),
                _AddressPreviewCard(addressesAsync: addressesAsync),
                const SizedBox(height: 16),
                _PromoPreviewCard(promosAsync: promosAsync),
                const SizedBox(height: 16),
                _SummaryCard(
                  subtotal: subtotal,
                  serviceFee: serviceFee,
                  shippingFee: shippingFee,
                  total: total,
                ),
              ],
            ),
      bottomNavigationBar: items.isEmpty
          ? null
          : SafeArea(
              minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: PremiumCard(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Total', style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(height: 4),
                          Text(
                            formatRupiah(total),
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: context.appColors.accent,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _checkout(context, ref, items),
                        child: const Text('Proceed to checkout'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _checkout(
    BuildContext context,
    WidgetRef ref,
    List<CartItem> items,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final user = await ref.read(currentUserProvider.future);
    if (user == null) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Login dulu untuk checkout.')),
      );
      return;
    }

    final defaultAddress = await ref.read(myAddressesProvider.future);
    if (defaultAddress.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Tambahkan alamat pengiriman terlebih dahulu.')),
      );
      return;
    }

    final cartNotifier = ref.read(cartProvider.notifier);
    final isValid = await cartNotifier.validateStockBeforeCheckout();
    if (!isValid) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Stok tidak cukup untuk salah satu item.')),
      );
      return;
    }

    AddressInfo preferredAddress = defaultAddress.first;
    for (final address in defaultAddress) {
      if (address.isDefault) {
        preferredAddress = address;
        break;
      }
    }
    final order = await ref.read(orderRepositoryProvider).createOrder(
          userId: user.id,
          items: items,
          addressId: preferredAddress.id,
        );
    await cartNotifier.clearCart();
    ref.invalidate(myOrdersProvider);
    messenger.showSnackBar(
      SnackBar(content: Text('Order ${order.orderNumber} berhasil dibuat.')),
    );
  }
}

class _CartItemCard extends ConsumerWidget {
  const _CartItemCard({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    final product = item.product;
    final displayPrice = item.unit == 'dos' && item.pcsPerDos != null
        ? formatRupiah(product.priceValue * item.pcsPerDos!)
        : product.price;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 82,
          height: 82,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              colors: [colors.surfaceMuted, const Color(0xFFE5EDFF)],
            ),
          ),
          child: Center(
            child: Text(
              product.sae,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colors.accent,
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
              Text(
                '${product.name} (${item.unit.toUpperCase()})',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                item.unit == 'dos'
                    ? '${product.brand} • 1 dos = ${item.pcsPerDos ?? '?'} pcs'
                    : product.brand,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 10),
              Text(
                displayPrice,
                style: theme.textTheme.titleLarge?.copyWith(color: colors.accent),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: colors.surfaceMuted,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add, size: 18),
                      onPressed: () async {
                        await ref.read(cartProvider.notifier).updateQuantity(
                              product.id,
                              item.unit,
                              item.quantity + 1,
                            );
                      },
                    ),
                    Text('${item.quantity}', style: theme.textTheme.labelLarge),
                    IconButton(
                      icon: const Icon(Icons.remove, size: 18),
                      onPressed: () async {
                        await ref.read(cartProvider.notifier).updateQuantity(
                              product.id,
                              item.unit,
                              item.quantity - 1,
                            );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () async {
                  await ref.read(cartProvider.notifier).removeProduct(product.id, item.unit);
                },
                child: const Text('Hapus'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CheckoutTimelineCard extends StatelessWidget {
  const _CheckoutTimelineCard({required this.items});

  final List<CartItem> items;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Order Tracking Timeline',
            subtitle: 'Preview alur setelah checkout selesai dibuat.',
          ),
          const SizedBox(height: 16),
          TimelineStep(
            title: 'Checkout dibuat',
            subtitle: '${items.length} item masuk ke pesanan.',
            isActive: true,
          ),
          const TimelineStep(
            title: 'Admin verifikasi',
            subtitle: 'Stok dan invoice dicek sebelum pengiriman.',
            isActive: true,
          ),
          const TimelineStep(
            title: 'Courier mengantar',
            subtitle: 'Status delivery akan diperbarui dari dashboard courier.',
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _AddressPreviewCard extends StatelessWidget {
  const _AddressPreviewCard({required this.addressesAsync});

  final AsyncValue<List<AddressInfo>> addressesAsync;

  @override
  Widget build(BuildContext context) {
    return addressesAsync.when(
      data: (addresses) {
        if (addresses.isEmpty) {
          return const EmptyStateCard(
            title: 'Alamat belum tersedia',
            message: 'Tambahkan alamat agar checkout bisa memakai pengiriman.',
            icon: Icons.location_on_outlined,
          );
        }
        var defaultAddress = addresses.first;
        for (final address in addresses) {
          if (address.isDefault) {
            defaultAddress = address;
            break;
          }
        }
        return PremiumCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.location_on_outlined),
            title: Text(defaultAddress.label),
            subtitle: Text(
              '${defaultAddress.recipientName} • ${defaultAddress.city}, ${defaultAddress.province}',
            ),
            trailing: const StatusBadge(label: 'Default'),
          ),
        );
      },
      loading: () => const LoadingCard(lines: 2),
      error: (error, _) => EmptyStateCard(
        title: 'Gagal memuat alamat',
        message: error.toString(),
        icon: Icons.error_outline_rounded,
      ),
    );
  }
}

class _PromoPreviewCard extends StatelessWidget {
  const _PromoPreviewCard({required this.promosAsync});

  final AsyncValue<List<PromoInfo>> promosAsync;

  @override
  Widget build(BuildContext context) {
    return promosAsync.when(
      data: (promos) {
        return PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'Promo & Voucher',
                subtitle: 'Voucher aktif yang bisa dipakai di checkout berikutnya.',
              ),
              const SizedBox(height: 12),
              if (promos.isEmpty)
                const Text('Belum ada promo aktif saat ini.')
              else
                ...promos.take(2).map(
                      (promo) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: StatusBadge(
                          label: '${promo.code} • ${promo.discountValue.toStringAsFixed(0)}%',
                          icon: Icons.local_offer_outlined,
                        ),
                      ),
                    ),
            ],
          ),
        );
      },
      loading: () => const LoadingCard(lines: 2),
      error: (error, _) => EmptyStateCard(
        title: 'Promo belum tersedia',
        message: error.toString(),
        icon: Icons.error_outline_rounded,
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.subtotal,
    required this.serviceFee,
    required this.shippingFee,
    required this.total,
  });

  final double subtotal;
  final double serviceFee;
  final double shippingFee;
  final double total;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        children: [
          _SummaryRow(label: 'Subtotal', value: formatRupiah(subtotal)),
          _SummaryRow(label: 'Biaya layanan', value: formatRupiah(serviceFee)),
          _SummaryRow(label: 'Estimasi kirim', value: formatRupiah(shippingFee)),
          const Divider(height: 28),
          _SummaryRow(
            label: 'Total',
            value: formatRupiah(total),
            valueColor: context.appColors.accent,
            isEmphasized: true,
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
          Text(value, style: textStyle?.copyWith(color: valueColor)),
        ],
      ),
    );
  }
}
