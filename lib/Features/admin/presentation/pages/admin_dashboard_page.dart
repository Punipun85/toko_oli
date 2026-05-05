import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toko_oli/core/models/app_entities.dart';
import 'package:toko_oli/core/presentation/formatters.dart';
import 'package:toko_oli/core/presentation/widgets/premium_ui.dart';
import 'package:toko_oli/core/providers/app_providers.dart';
import 'package:toko_oli/core/theme/app_theme.dart';
import 'package:toko_oli/features/auth/data/auth_repository.dart';

class AdminDashboardPage extends ConsumerWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(adminSummaryProvider);
    final recentOrdersAsync = ref.watch(adminRecentOrdersProvider);
    final lowStockAsync = ref.watch(adminLowStockProvider);
    final bestSellingAsync = ref.watch(adminBestSellingProvider);
    final revenueAsync = ref.watch(adminRevenueChartProvider);
    final statusOverviewAsync = ref.watch(adminOrderStatusOverviewProvider);
    final brandsAsync = ref.watch(brandsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final brands = brandsAsync.asData?.value;
          final categories = categoriesAsync.asData?.value;
          if (brands == null || brands.isEmpty || categories == null || categories.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Brand dan kategori belum siap.')),
            );
            return;
          }
          await _showCreateProductDialog(
            context,
            ref,
            brands: brands,
            categories: categories,
          );
        },
        icon: const Icon(Icons.add_business_rounded),
        label: const Text('New Product'),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshAdminProviders(ref),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            const SectionHeader(
              title: 'Store Control Room',
              subtitle: 'Polish fokus pada KPI, status order, stok rendah, dan quick actions tanpa mengubah arsitektur.',
            ),
            const SizedBox(height: 16),
            summaryAsync.when(
              data: (summary) => _KpiGrid(summary: summary),
              loading: () => const LoadingCard(lines: 4),
              error: (error, _) => _ErrorCard(
                message: error.toString(),
                onRetry: () => ref.invalidate(adminSummaryProvider),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _RevenueSection(revenueAsync: revenueAsync)),
                const SizedBox(width: 12),
                Expanded(
                  child: _OrderStatusSection(statusOverviewAsync: statusOverviewAsync),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const SectionHeader(
              title: 'Management Menu',
              subtitle: 'Shortcut polished untuk product, stock, promo, report, store settings, dan role management.',
            ),
            const SizedBox(height: 12),
            const _ManagementGrid(),
            const SizedBox(height: 24),
            _RecentOrdersSection(recentOrdersAsync: recentOrdersAsync),
            const SizedBox(height: 24),
            _LowStockSection(lowStockAsync: lowStockAsync),
            const SizedBox(height: 24),
            _BestSellingSection(bestSellingAsync: bestSellingAsync),
          ],
        ),
      ),
    );
  }
}

class _KpiGrid extends StatelessWidget {
  const _KpiGrid({required this.summary});

  final DashboardSummaryInfo summary;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.18,
      children: [
        StatCard(
          label: 'Today Sales',
          value: formatRupiah(summary.todaySales),
          subtitle: 'Revenue harian',
          icon: Icons.payments_outlined,
        ),
        StatCard(
          label: 'New Orders',
          value: '${summary.newOrders}',
          subtitle: 'Pesanan baru',
          icon: Icons.receipt_long_outlined,
          highlightColor: context.appColors.gold,
        ),
        StatCard(
          label: 'To Process',
          value: '${summary.ordersToProcess}',
          subtitle: 'Perlu diproses',
          icon: Icons.pending_actions_outlined,
        ),
        StatCard(
          label: 'Low Stock',
          value: '${summary.lowStockProducts}',
          subtitle: 'Butuh restock',
          icon: Icons.warning_amber_rounded,
          highlightColor: context.appColors.gold,
        ),
      ],
    );
  }
}

class _RevenueSection extends StatelessWidget {
  const _RevenueSection({required this.revenueAsync});

  final AsyncValue<List<Map<String, Object>>> revenueAsync;

  @override
  Widget build(BuildContext context) {
    return revenueAsync.when(
      data: (items) => PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'Revenue Chart',
              subtitle: 'Section chart ringan untuk monitoring cepat.',
            ),
            const SizedBox(height: 16),
            ...items.map(
              (item) {
                final value = (item['value'] as num?)?.toDouble() ?? 0;
                final widthFactor = value <= 0 ? 0.08 : value > 1000000 ? 1.0 : value / 1000000;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${item['label']}', style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: widthFactor.clamp(0.08, 1.0),
                          minHeight: 12,
                          backgroundColor: context.appColors.surfaceMuted,
                          color: context.appColors.accent,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(formatRupiah(value), style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      loading: () => const LoadingCard(lines: 4),
      error: (error, _) => _ErrorCard(message: error.toString(), onRetry: () {}),
    );
  }
}

class _OrderStatusSection extends StatelessWidget {
  const _OrderStatusSection({required this.statusOverviewAsync});

  final AsyncValue<List<Map<String, Object>>> statusOverviewAsync;

  @override
  Widget build(BuildContext context) {
    return statusOverviewAsync.when(
      data: (items) => PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'Order Status',
              subtitle: 'Overview status order terkini.',
            ),
            const SizedBox(height: 16),
            if (items.isEmpty)
              const Text('Belum ada data status order.')
            else
              ...items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          titleCaseStatus('${item['status'] ?? ''}'),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      StatusBadge(label: '${item['count'] ?? 0}'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      loading: () => const LoadingCard(lines: 4),
      error: (error, _) => _ErrorCard(message: error.toString(), onRetry: () {}),
    );
  }
}

class _ManagementGrid extends StatelessWidget {
  const _ManagementGrid();

  @override
  Widget build(BuildContext context) {
    const items = <(String, IconData)>[
      ('Product Management', Icons.inventory_2_outlined),
      ('Variant Management', Icons.tune_rounded),
      ('Stock Management', Icons.warehouse_outlined),
      ('Promo Management', Icons.local_offer_outlined),
      ('Report Screen', Icons.insights_outlined),
      ('Store Settings', Icons.settings_outlined),
      ('Role Management', Icons.admin_panel_settings_outlined),
      ('More Menu', Icons.more_horiz_rounded),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.45,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return PremiumCard(
          child: InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${item.$1} disiapkan sebagai area UI berikutnya.')),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(item.$2, color: context.appColors.accent),
                const Spacer(),
                Text(item.$1, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RecentOrdersSection extends StatelessWidget {
  const _RecentOrdersSection({required this.recentOrdersAsync});

  final AsyncValue<List<OrderInfo>> recentOrdersAsync;

  @override
  Widget build(BuildContext context) {
    return recentOrdersAsync.when(
      data: (orders) => PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'Recent Orders',
              subtitle: 'Daftar pesanan terbaru dengan action cepat admin.',
            ),
            const SizedBox(height: 12),
            if (orders.isEmpty)
              const Text('Belum ada order.')
            else
              ...orders.map(
                (order) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(order.orderNumber),
                    subtitle: Text(
                      '${titleCaseStatus(order.orderStatus)} • ${titleCaseStatus(order.paymentStatus)}',
                    ),
                    trailing: Text(formatRupiah(order.grandTotal)),
                  ),
                ),
              ),
          ],
        ),
      ),
      loading: () => const LoadingCard(lines: 4),
      error: (error, _) => _ErrorCard(message: error.toString(), onRetry: () {}),
    );
  }
}

class _LowStockSection extends StatelessWidget {
  const _LowStockSection({required this.lowStockAsync});

  final AsyncValue<List<ProductVariantInfo>> lowStockAsync;

  @override
  Widget build(BuildContext context) {
    return lowStockAsync.when(
      data: (variants) => PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'Low Stock Alert',
              subtitle: 'Restock cepat dan area stock management yang lebih jelas.',
            ),
            const SizedBox(height: 12),
            if (variants.isEmpty)
              const Text('Stok aman.')
            else
              ...variants.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.volumeLabel.isEmpty ? item.name : item.volumeLabel,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(item.name, style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ),
                      StatusBadge(
                        label: '${item.stockQuantity}/${item.minimumStock}',
                        backgroundColor: context.appColors.gold.withValues(alpha: 0.16),
                        foregroundColor: context.appColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      loading: () => const LoadingCard(lines: 3),
      error: (error, _) => _ErrorCard(message: error.toString(), onRetry: () {}),
    );
  }
}

class _BestSellingSection extends StatelessWidget {
  const _BestSellingSection({required this.bestSellingAsync});

  final AsyncValue<List<Map<String, Object>>> bestSellingAsync;

  @override
  Widget build(BuildContext context) {
    return bestSellingAsync.when(
      data: (items) => PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'Best Selling Products',
              subtitle: 'Ringkasan produk terlaris untuk report dan promo decisions.',
            ),
            const SizedBox(height: 12),
            if (items.isEmpty)
              const Text('Belum ada data penjualan.')
            else
              ...items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.workspace_premium_outlined),
                    title: Text('${item['product_name'] ?? '-'}'),
                    subtitle: Text('Units sold: ${item['units_sold'] ?? 0}'),
                    trailing: Text('${item['revenue'] ?? 0}'),
                  ),
                ),
              ),
          ],
        ),
      ),
      loading: () => const LoadingCard(lines: 3),
      error: (error, _) => _ErrorCard(message: error.toString(), onRetry: () {}),
    );
  }
}

Future<void> _refreshAdminProviders(WidgetRef ref) async {
  ref.invalidate(adminSummaryProvider);
  ref.invalidate(adminRecentOrdersProvider);
  ref.invalidate(adminLowStockProvider);
  ref.invalidate(adminBestSellingProvider);
  ref.invalidate(adminRevenueChartProvider);
  ref.invalidate(adminOrderStatusOverviewProvider);
  ref.invalidate(activeProductsProvider);
}

Future<void> _showCreateProductDialog(
  BuildContext context,
  WidgetRef ref, {
  required List<BrandInfo> brands,
  required List<CategoryInfo> categories,
}) async {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final viscosityController = TextEditingController(text: '10W-40');
  var selectedBrandId = brands.first.id;
  var selectedCategoryId = categories.first.id;

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add Product'),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Nama produk'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nama produk wajib diisi.';
                        }
                        if (value.trim().length < 4) {
                          return 'Nama produk minimal 4 karakter.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: selectedBrandId,
                      decoration: const InputDecoration(labelText: 'Brand'),
                      items: brands
                          .map(
                            (brand) => DropdownMenuItem<String>(
                              value: brand.id,
                              child: Text(brand.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => selectedBrandId = value);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: selectedCategoryId,
                      decoration: const InputDecoration(labelText: 'Kategori'),
                      items: categories
                          .map(
                            (category) => DropdownMenuItem<String>(
                              value: category.id,
                              child: Text(category.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => selectedCategoryId = value);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: viscosityController,
                      decoration: const InputDecoration(labelText: 'Viscosity'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Viscosity wajib diisi.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: 'Deskripsi'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Deskripsi wajib diisi.';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Batal'),
              ),
              FilledButton(
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  if (!formKey.currentState!.validate()) {
                    return;
                  }
                  await ref.read(productRepositoryProvider).createProduct(
                        name: nameController.text.trim(),
                        brandId: selectedBrandId,
                        categoryId: selectedCategoryId,
                        viscosity: viscosityController.text.trim(),
                        description: descriptionController.text.trim(),
                      );
                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop();
                  }
                  ref.invalidate(activeProductsProvider);
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Produk baru berhasil dibuat.')),
                  );
                },
                child: const Text('Simpan'),
              ),
            ],
          );
        },
      );
    },
  );

  nameController.dispose();
  descriptionController.dispose();
  viscosityController.dispose();
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return EmptyStateCard(
      title: 'Gagal memuat data',
      message: message,
      icon: Icons.error_outline_rounded,
      action: ElevatedButton(
        onPressed: onRetry,
        child: const Text('Coba lagi'),
      ),
    );
  }
}
