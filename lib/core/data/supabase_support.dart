import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toko_oli/core/network/supabase_config.dart';

final supabaseClientProvider = Provider<SupabaseClient?>((ref) {
  if (!SupabaseConfig.isConfigured) {
    return null;
  }

  try {
    return Supabase.instance.client;
  } catch (_) {
    return null;
  }
});

bool isSupabaseReady(SupabaseClient? client) => SupabaseConfig.isConfigured && client != null;
