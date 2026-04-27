import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Akun Saya')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF1C2024),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFFFF6B00), Color(0xFFFFB693)],
                    ),
                  ),
                  child: const Icon(Icons.person_rounded, color: Colors.black, size: 34),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Budi Santoso', style: theme.textTheme.titleLarge),
                      const SizedBox(height: 4),
                      Text('0812-3456-7890', style: theme.textTheme.bodyMedium),
                      const SizedBox(height: 10),
                      const Chip(label: Text('Honda Vario 150')),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Pengaturan Akun', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          _buildMenuTile(Icons.location_on_outlined, 'Daftar alamat pengiriman'),
          _buildMenuTile(Icons.two_wheeler_rounded, 'Garasi / kendaraan saya'),
          _buildMenuTile(Icons.credit_card_rounded, 'Metode pembayaran'),
          const SizedBox(height: 18),
          Text('Bantuan', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          _buildMenuTile(Icons.help_outline_rounded, 'Pusat bantuan / FAQ'),
          _buildMenuTile(Icons.lock_outline_rounded, 'Keamanan & password'),
          const SizedBox(height: 26),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2024),
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFFFB693)),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () {},
      ),
    );
  }
}
