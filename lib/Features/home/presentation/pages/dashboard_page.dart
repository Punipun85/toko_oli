import 'package:flutter/material.dart';
import 'package:toko_oli/Features/cart/presentation/pages/cart_page.dart';
import 'package:toko_oli/Features/home/presentation/pages/catalog_page.dart';
import 'package:toko_oli/Features/home/presentation/pages/home_page.dart';
import 'package:toko_oli/Features/profile/presentation/pages/profile_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  late final List<Widget> _pages = const [
    HomePage(),
    CatalogPage(),
    CartPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Katalog'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_rounded), label: 'Keranjang'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Akun'),
        ],
      ),
    );
  }
}
