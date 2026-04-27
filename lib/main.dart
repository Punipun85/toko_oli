import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toko_oli/Features/home/presentation/pages/dashboard_page.dart';
import 'package:toko_oli/app/supabase_config.dart';
import 'package:toko_oli/app/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.publishableKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Oil Store',
      debugShowCheckedModeBanner: false,
      theme: buildTokoOliTheme(),
      home: const DashboardPage(),
    );
  }
}
