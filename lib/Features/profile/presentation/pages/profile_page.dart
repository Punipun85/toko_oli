import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toko_oli/core/models/app_entities.dart';
import 'package:toko_oli/core/presentation/formatters.dart';
import 'package:toko_oli/core/presentation/widgets/premium_ui.dart';
import 'package:toko_oli/core/providers/app_providers.dart';
import 'package:toko_oli/core/theme/app_theme.dart';
import 'package:toko_oli/features/auth/data/auth_repository.dart';
import 'package:toko_oli/features/auth/presentation/pages/login_page.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentProfileProvider);
    final ordersAsync = ref.watch(myOrdersProvider);
    final wishlistAsync = ref.watch(myWishlistProvider);
    final remindersAsync = ref.watch(myRemindersProvider);
    final articlesAsync = ref.watch(publishedArticlesProvider);

    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(title: const Text('Account')),
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: EmptyStateCard(
                  title: 'Anda belum login',
                  message: 'Masuk untuk menyimpan kendaraan, alamat, wishlist, dan histori belanja.',
                  icon: Icons.person_outline_rounded,
                  action: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                    child: const Text('Login atau daftar'),
                  ),
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              _ProfileHero(profile: profile),
              const SizedBox(height: 24),
              _OrderOverviewSection(ordersAsync: ordersAsync),
              const SizedBox(height: 20),
              _GarageReminderSection(remindersAsync: remindersAsync),
              const SizedBox(height: 20),
              _WishlistSection(wishlistAsync: wishlistAsync),
              const SizedBox(height: 20),
              const _NotificationSection(),
              const SizedBox(height: 20),
              _ArticleBookmarkSection(articlesAsync: articlesAsync),
              const SizedBox(height: 20),
              const _AccountMenuSection(),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () => ref.read(authRepositoryProvider).signOut(),
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Keluar'),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
      ),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({required this.profile});

  final AppProfile profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.primary,
            const Color(0xFF25334B),
            colors.accent,
          ],
        ),
      ),
      padding: const EdgeInsets.all(22),
      child: Row(
        children: [
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
            ),
            child: const Icon(Icons.person_rounded, color: Colors.white, size: 34),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.fullName,
                  style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  profile.email,
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    StatusBadge(
                      label: titleCaseStatus(profile.role),
                      backgroundColor: const Color(0x24FFFFFF),
                      foregroundColor: Colors.white,
                      icon: Icons.verified_user_outlined,
                    ),
                    StatusBadge(
                      label: titleCaseStatus(profile.accountType),
                      backgroundColor: const Color(0x24FFFFFF),
                      foregroundColor: Colors.white,
                      icon: Icons.storefront_outlined,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderOverviewSection extends StatelessWidget {
  const _OrderOverviewSection({required this.ordersAsync});

  final AsyncValue<List<OrderInfo>> ordersAsync;

  @override
  Widget build(BuildContext context) {
    return ordersAsync.when(
      data: (orders) {
        final recent = orders.isEmpty ? null : orders.first;
        return PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'Order Tracking',
                subtitle: 'Status pesanan terbaru dan timeline yang lebih mudah dibaca.',
              ),
              const SizedBox(height: 16),
              if (recent == null)
                const Text('Belum ada pesanan. Setelah checkout, status akan muncul di sini.')
              else ...[
                Text(recent.orderNumber, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  '${titleCaseStatus(recent.orderStatus)} • ${formatShortDate(recent.createdAt)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                TimelineStep(
                  title: 'Order dibuat',
                  subtitle: 'Pesanan sudah tercatat di sistem.',
                  isActive: true,
                ),
                TimelineStep(
                  title: 'Diproses',
                  subtitle: 'Admin menyiapkan pesanan.',
                  isActive: recent.orderStatus != 'pending',
                ),
                TimelineStep(
                  title: 'Dikirim',
                  subtitle: recent.trackingNumber == null
                      ? 'Nomor resi akan muncul setelah dispatch.'
                      : 'Resi ${recent.trackingNumber}',
                  isActive: recent.orderStatus == 'shipped' || recent.orderStatus == 'completed',
                  isLast: true,
                ),
              ],
            ],
          ),
        );
      },
      loading: () => const LoadingCard(lines: 4),
      error: (error, _) => EmptyStateCard(
        title: 'Gagal memuat order',
        message: error.toString(),
        icon: Icons.error_outline_rounded,
      ),
    );
  }
}

class _GarageReminderSection extends StatelessWidget {
  const _GarageReminderSection({required this.remindersAsync});

  final AsyncValue<List<OilChangeReminderInfo>> remindersAsync;

  @override
  Widget build(BuildContext context) {
    return remindersAsync.when(
      data: (reminders) => PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'Oil Recommendation Flow',
              subtitle: 'Ringkasan garage, reminder, dan langkah servis berikutnya.',
            ),
            const SizedBox(height: 16),
            StatCard(
              label: 'Reminder aktif',
              value: '${reminders.length}',
              subtitle: reminders.isEmpty
                  ? 'Tambahkan kendaraan untuk mulai reminder'
                  : 'Jadwal penggantian berikutnya tersimpan',
              icon: Icons.schedule_outlined,
              highlightColor: context.appColors.gold,
            ),
          ],
        ),
      ),
      loading: () => const LoadingCard(lines: 3),
      error: (error, _) => EmptyStateCard(
        title: 'Reminder belum siap',
        message: error.toString(),
        icon: Icons.error_outline_rounded,
      ),
    );
  }
}

class _WishlistSection extends StatelessWidget {
  const _WishlistSection({required this.wishlistAsync});

  final AsyncValue<List<dynamic>> wishlistAsync;

  @override
  Widget build(BuildContext context) {
    return wishlistAsync.when(
      data: (wishlist) => PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'Wishlist',
              subtitle: 'Produk yang ingin dibeli nanti tetap mudah dipantau.',
            ),
            const SizedBox(height: 12),
            if (wishlist.isEmpty)
              const Text('Belum ada produk tersimpan di wishlist.')
            else
              ...wishlist.take(3).map(
                    (product) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.favorite_border_rounded),
                        title: Text(product.name),
                        subtitle: Text('${product.brand} • ${product.sae}'),
                      ),
                    ),
                  ),
          ],
        ),
      ),
      loading: () => const LoadingCard(lines: 3),
      error: (error, _) => EmptyStateCard(
        title: 'Wishlist belum tersedia',
        message: error.toString(),
        icon: Icons.error_outline_rounded,
      ),
    );
  }
}

class _NotificationSection extends StatelessWidget {
  const _NotificationSection();

  @override
  Widget build(BuildContext context) {
    const notifications = <(String, String, IconData)>[
      ('Promo akhir pekan aktif', 'Voucher checkout tersedia sampai Minggu malam.', Icons.local_offer_outlined),
      ('Stok produk favorit kembali', 'Beberapa varian populer sudah kembali siap kirim.', Icons.inventory_2_outlined),
      ('Reminder servis mendekat', 'Jangan lewatkan jadwal ganti oli berikutnya.', Icons.schedule_outlined),
    ];

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Notification List',
            subtitle: 'Placeholder list untuk notifikasi pelanggan yang lebih rapi.',
          ),
          const SizedBox(height: 12),
          ...notifications.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(item.$3, color: context.appColors.accent),
                title: Text(item.$1),
                subtitle: Text(item.$2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArticleBookmarkSection extends StatelessWidget {
  const _ArticleBookmarkSection({required this.articlesAsync});

  final AsyncValue<List<ArticleInfo>> articlesAsync;

  @override
  Widget build(BuildContext context) {
    return articlesAsync.when(
      data: (articles) => PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'Articles & Reading',
              subtitle: 'Konten edukasi untuk mendukung keputusan beli dan maintenance.',
            ),
            const SizedBox(height: 12),
            if (articles.isEmpty)
              const Text('Belum ada artikel yang dipublikasikan.')
            else
              ...articles.take(2).map(
                    (article) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
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

class _AccountMenuSection extends StatelessWidget {
  const _AccountMenuSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SectionHeader(
          title: 'Account & Support',
          subtitle: 'Akses cepat ke area yang sering dibuka pengguna.',
        ),
        SizedBox(height: 10),
        _MenuTile(icon: Icons.location_on_outlined, title: 'Daftar alamat pengiriman'),
        _MenuTile(icon: Icons.two_wheeler_rounded, title: 'Garasi dan kendaraan saya'),
        _MenuTile(icon: Icons.credit_card_rounded, title: 'Metode pembayaran'),
        _MenuTile(icon: Icons.help_outline_rounded, title: 'Pusat bantuan dan FAQ'),
      ],
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: PremiumCard(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: ListTile(
          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: colors.surfaceMuted,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: colors.primary),
          ),
          title: Text(title),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () {},
        ),
      ),
    );
  }
}
