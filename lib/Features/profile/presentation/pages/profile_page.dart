import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Akun Saya', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 1. Header (Info User & Garasi)
          Row(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.person, size: 40, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Budi Santoso', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('0812-3456-7890', style: TextStyle(color: Colors.grey.shade700)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('🏍️ Honda Vario 150', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // 2. Kategori: Pengaturan Akun
          const Text('PENGATURAN AKUN', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 10),
          _buildMenuTile(Icons.location_on_outlined, 'Daftar Alamat Pengiriman'),
          _buildMenuTile(Icons.two_wheeler, 'Garasi / Kendaraan Saya'),
          _buildMenuTile(Icons.credit_card, 'Metode Pembayaran'),
          const Divider(height: 30),

          // 3. Kategori: Bantuan & Info
          const Text('BANTUAN & INFO', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 10),
          _buildMenuTile(Icons.help_outline, 'Pusat Bantuan / FAQ'),
          _buildMenuTile(Icons.lock_outline, 'Keamanan & Password'),
          const Divider(height: 30),

          // 4. Tombol Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Keluar', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile(IconData icon, String title) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.blueGrey),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {},
    );
  }
}