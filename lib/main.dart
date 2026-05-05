import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toko_oli/app/app_home_router.dart';
import 'package:toko_oli/core/network/supabase_config.dart';
import 'package:toko_oli/core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _loadEnvFile();
  await _initializeSupabaseIfConfigured();

  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _loadEnvFile() async {
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // `.env` is optional so the app can still run with dummy data.
  }
}

Future<void> _initializeSupabaseIfConfigured() async {
  if (!SupabaseConfig.isConfigured) {
    debugPrint(
      'Supabase not configured. Falling back to local dummy product data.',
    );
    return;
  }

  try {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
  } catch (error, stackTrace) {
    debugPrint('Supabase initialization failed: $error');
    debugPrintStack(stackTrace: stackTrace);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OliMart',
      debugShowCheckedModeBanner: false,
      theme: buildTokoOliTheme(),
      home: const AppHomeRouter(),
    );
  }
}
