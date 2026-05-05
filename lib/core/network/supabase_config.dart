import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConfig {
  const SupabaseConfig._();

  static const String _publishableKeyPrefix = 'sb_publishable_';
  static const String _compileTimeUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );
  static const String _compileTimeAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  static String get url => _read('SUPABASE_URL', _compileTimeUrl);

  static String get anonKey => _read('SUPABASE_ANON_KEY', _compileTimeAnonKey);

  static bool get isConfigured {
    return _isValidUrl(url) && _isValidAnonKey(anonKey);
  }

  static String _read(String key, String fallback) {
    try {
      final dotenvValue = dotenv.maybeGet(key)?.trim();
      if (dotenvValue != null && dotenvValue.isNotEmpty) {
        return dotenvValue;
      }
    } catch (_) {
      // Dotenv is optional in tests and offline mode.
    }

    return fallback.trim();
  }

  static bool _isValidUrl(String value) {
    final uri = Uri.tryParse(value);
    return uri != null && uri.hasScheme && uri.host.isNotEmpty;
  }

  static bool _isValidAnonKey(String value) {
    return value.startsWith(_publishableKeyPrefix) && value.length > _publishableKeyPrefix.length;
  }
}
