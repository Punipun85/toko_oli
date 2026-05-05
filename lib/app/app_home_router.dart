import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toko_oli/core/presentation/widgets/premium_ui.dart';
import 'package:toko_oli/core/theme/app_theme.dart';
import 'package:toko_oli/features/admin/presentation/pages/admin_dashboard_page.dart';
import 'package:toko_oli/features/auth/data/auth_repository.dart';
import 'package:toko_oli/features/courier/presentation/pages/courier_dashboard_page.dart';
import 'package:toko_oli/features/home/presentation/pages/dashboard_page.dart';

class AppHomeRouter extends ConsumerWidget {
  const AppHomeRouter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roleAsync = ref.watch(currentRoleProvider);

    return roleAsync.when(
      data: (role) {
        switch (role) {
          case 'admin':
            return const AdminDashboardPage();
          case 'courier':
            return const CourierDashboardPage();
          case 'customer':
          default:
            return const DashboardPage();
        }
      },
      loading: () => Scaffold(
        backgroundColor: context.appColors.background,
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        backgroundColor: context.appColors.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: EmptyStateCard(
              title: 'Gagal membaca sesi',
              message: error.toString(),
              icon: Icons.error_outline_rounded,
              action: ElevatedButton(
                onPressed: () => ref.invalidate(currentRoleProvider),
                child: const Text('Coba lagi'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
