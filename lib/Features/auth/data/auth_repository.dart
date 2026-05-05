import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toko_oli/core/data/supabase_support.dart';
import 'package:toko_oli/core/models/app_entities.dart';

class AuthRepository {
  AuthRepository(this._supabase);

  final SupabaseClient? _supabase;
  final StreamController<AuthState> _fallbackController =
      StreamController<AuthState>.broadcast();

  Stream<AuthState> get authStateChanges {
    final supabase = _supabase;
    if (supabase != null) {
      return supabase.auth.onAuthStateChange;
    }

    return _fallbackController.stream;
  }

  User? get currentUser => _supabase?.auth.currentUser;

  Future<void> signIn(String email, String password) async {
    final supabase = _supabase;
    if (supabase == null) {
      throw Exception('Supabase belum dikonfigurasi. Login online tidak tersedia.');
    }

    await supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signUp(
    String email,
    String password, {
    String? fullName,
  }) async {
    final supabase = _supabase;
    if (supabase == null) {
      throw Exception('Supabase belum dikonfigurasi. Registrasi online tidak tersedia.');
    }

    await supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        if (fullName != null && fullName.trim().isNotEmpty)
          'full_name': fullName.trim(),
      },
    );
  }

  Future<void> signInWithEmail(String email, String password) =>
      signIn(email, password);

  Future<void> signUpWithEmail(
    String email,
    String password, {
    String? fullName,
  }) =>
      signUp(email, password, fullName: fullName);

  Future<void> signOut() async {
    final supabase = _supabase;
    if (supabase != null) {
      await supabase.auth.signOut();
    }
  }

  Future<User?> getCurrentUser() async => currentUser;

  Future<AppProfile?> getCurrentProfile() async {
    final user = currentUser;
    if (user == null) {
      return null;
    }

    final fallbackProfile = AppProfile(
      id: user.id,
      email: user.email ?? '',
      fullName: (user.userMetadata?['full_name']?.toString().trim().isNotEmpty ??
              false)
          ? user.userMetadata!['full_name'].toString()
          : (user.email ?? 'Pengguna'),
      role: 'customer',
      accountType: 'regular',
    );

    final supabase = _supabase;
    if (supabase == null) {
      return fallbackProfile;
    }

    try {
      final response = await supabase
          .from('profiles')
          .select('id,email,full_name,role,account_type')
          .eq('id', user.id)
          .maybeSingle();

      if (response == null) {
        return fallbackProfile;
      }

      return AppProfile(
        id: response['id'].toString(),
        email: (response['email'] ?? user.email ?? '').toString(),
        fullName: (response['full_name'] ?? fallbackProfile.fullName).toString(),
        role: (response['role'] ?? 'customer').toString(),
        accountType: (response['account_type'] ?? 'regular').toString(),
      );
    } catch (_) {
      return fallbackProfile;
    }
  }

  Future<String> checkUserRole() async {
    final profile = await getCurrentProfile();
    return profile?.role ?? 'customer';
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(supabaseClientProvider));
});

final authStateProvider = StreamProvider<AuthState>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.authStateChanges;
});

final currentUserProvider = FutureProvider<User?>((ref) async {
  final authRepo = ref.watch(authRepositoryProvider);
  ref.watch(authStateProvider);
  return authRepo.getCurrentUser();
});

final currentProfileProvider = FutureProvider<AppProfile?>((ref) async {
  ref.watch(authStateProvider);
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.getCurrentProfile();
});

final currentRoleProvider = FutureProvider<String?>((ref) async {
  final profile = await ref.watch(currentProfileProvider.future);
  return profile?.role;
});
