import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toko_oli/core/presentation/widgets/premium_ui.dart';
import 'package:toko_oli/core/providers/app_providers.dart';
import 'package:toko_oli/core/theme/app_theme.dart';
import 'package:toko_oli/features/auth/data/auth_repository.dart';

class CourierDashboardPage extends ConsumerWidget {
  const CourierDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deliveriesAsync = ref.watch(assignedDeliveriesProvider);

    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        title: const Text('Courier Dashboard'),
        actions: [
          IconButton(
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(assignedDeliveriesProvider),
        child: deliveriesAsync.when(
          data: (deliveries) => ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              const SectionHeader(
                title: 'Courier Delivery Board',
                subtitle: 'Status pengantaran, update delivery, dan placeholder upload proof dibuat lebih jelas.',
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.22,
                children: [
                  StatCard(
                    label: 'Assigned',
                    value: '${deliveries.length}',
                    subtitle: 'Pesanan aktif',
                    icon: Icons.local_shipping_outlined,
                  ),
                  StatCard(
                    label: 'Delivered',
                    value: '${deliveries.where((item) => item.status == 'delivered').length}',
                    subtitle: 'Sudah selesai',
                    icon: Icons.task_alt_rounded,
                    highlightColor: context.appColors.gold,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (deliveries.isEmpty)
                const EmptyStateCard(
                  title: 'Belum ada pengiriman',
                  message: 'Assignment courier akan tampil di sini.',
                  icon: Icons.local_shipping_outlined,
                )
              else
                ...deliveries.map(
                  (delivery) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _DeliveryCard(delivery: delivery),
                  ),
                ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text(error.toString())),
        ),
      ),
    );
  }
}

class _DeliveryCard extends ConsumerWidget {
  const _DeliveryCard({required this.delivery});

  final dynamic delivery;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      delivery.orderNumber ?? delivery.orderId,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Delivery order detail untuk assignment courier aktif.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              StatusBadge(label: delivery.status, icon: Icons.flag_outlined),
            ],
          ),
          const SizedBox(height: 16),
          const TimelineStep(
            title: 'Pickup terjadwal',
            subtitle: 'Item sudah disiapkan admin untuk diantar.',
            isActive: true,
          ),
          TimelineStep(
            title: 'Dalam pengiriman',
            subtitle: 'Update status saat order sudah dibawa courier.',
            isActive: delivery.status == 'in_transit' || delivery.status == 'delivered',
          ),
          TimelineStep(
            title: 'Proof of delivery',
            subtitle: 'Placeholder upload bukti kirim tetap tersedia.',
            isActive: delivery.status == 'delivered',
            isLast: true,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    await ref
                        .read(courierRepositoryProvider)
                        .updateDeliveryStatus(delivery.id, 'in_transit');
                    ref.invalidate(assignedDeliveriesProvider);
                  },
                  child: const Text('Mark In Transit'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await ref
                        .read(courierRepositoryProvider)
                        .updateDeliveryStatus(delivery.id, 'delivered');
                    ref.invalidate(assignedDeliveriesProvider);
                  },
                  child: const Text('Mark Delivered'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FilledButton.tonalIcon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Placeholder upload delivery proof siap dihubungkan ke image picker.'),
                  ),
                );
              },
              icon: const Icon(Icons.camera_alt_outlined),
              label: const Text('Upload delivery proof'),
            ),
          ),
        ],
      ),
    );
  }
}
