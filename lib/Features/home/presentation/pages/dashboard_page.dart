import 'package:flutter/material.dart';
import 'home_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
// Import file halaman Anda di sini:
// import 'home_page.dart';
// import '../profile/presentation/pages/profile_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  // Daftar halaman yang akan ditampilkan berdasarkan indeks menu bawah
  final List<Widget> _pages = [
    const HomePage(),
    const Center(child: Text('Halaman Pesanan (Belum Dibuat)')), // Placeholder Pesanan
    const Center(child: Text('Halaman Troly (Belum Dibuat)')),   // Placeholder Troly
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body akan berubah-ubah sesuai menu yang diklik
      body: _pages[_selectedIndex],
      
      // Bottom Navigation Bar dipusatkan di sini
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Pesanan'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Troly'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
      ),
    );
  }
}