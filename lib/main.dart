import 'package:flutter/material.dart';
import 'package:toko_oli/Features/home/presentation/pages/dashboard_page.dart';

void main() {
  runApp(const TokoOliApp());
}

class TokoOliApp extends StatelessWidget {
  const TokoOliApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Toko Oli',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: false, 
        ),
        useMaterial3: true,
      ),
      home: const DashboardPage(),
    );
  }
}

