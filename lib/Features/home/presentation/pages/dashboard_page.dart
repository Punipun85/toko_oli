import 'package:flutter/material.dart';
import 'package:toko_oli/features/cart/presentation/pages/cart_page.dart';
import 'package:toko_oli/features/home/presentation/pages/catalog_page.dart';
import 'package:toko_oli/features/home/presentation/pages/home_page.dart';
import 'package:toko_oli/features/profile/presentation/pages/profile_page.dart';

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
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
            height: 74,
            backgroundColor: Theme.of(context).colorScheme.surface,
            indicatorColor:
                Theme.of(context).colorScheme.secondary.withValues(alpha: 0.14),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.grid_view_outlined),
                selectedIcon: Icon(Icons.grid_view_rounded),
                label: 'Catalog',
              ),
              NavigationDestination(
                icon: Icon(Icons.shopping_cart_outlined),
                selectedIcon: Icon(Icons.shopping_cart_rounded),
                label: 'Cart',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
