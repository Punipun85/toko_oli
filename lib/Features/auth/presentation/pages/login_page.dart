import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toko_oli/core/presentation/widgets/premium_ui.dart';
import 'package:toko_oli/core/theme/app_theme.dart';
import 'package:toko_oli/features/auth/data/auth_repository.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isLogin = true;
  bool _showPassword = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      final authRepo = ref.read(authRepositoryProvider);
      if (_isLogin) {
        await authRepo.signInWithEmail(email, password);
      } else {
        await authRepo.signUpWithEmail(
          email,
          password,
          fullName: _nameController.text.trim(),
        );
      }
      if (!mounted) {
        return;
      }

      messenger.showSnackBar(
        SnackBar(
          content: Text(
            _isLogin
                ? 'Login berhasil.'
                : 'Registrasi berhasil. Silakan cek email jika verifikasi diaktifkan.',
          ),
        ),
      );
      navigator.pop();
    } catch (error) {
      if (mounted) {
        messenger.showSnackBar(SnackBar(content: Text(error.toString())));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: Text(_isLogin ? 'Login' : 'Daftar')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PremiumCard(
                    radius: 30,
                    backgroundColor: Colors.transparent,
                    borderColor: colors.outline,
                    padding: EdgeInsets.zero,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colors.primary,
                            const Color(0xFF1F2937),
                            colors.accent,
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const MetricPill(
                            label: 'Secure Supabase Auth',
                            icon: Icons.lock_outline_rounded,
                            backgroundColor: Color(0x24FFFFFF),
                            foregroundColor: Colors.white,
                          ),
                          const SizedBox(height: 18),
                          Text(
                            _isLogin ? 'Masuk ke akun Anda' : 'Buat akun baru',
                            style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _isLogin
                                ? 'Lanjutkan belanja oli, lihat tracking, dan akses dashboard sesuai role.'
                                : 'Akun akan tersimpan di Supabase Auth dan profil publik aplikasi.',
                            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  PremiumCard(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (!_isLogin) ...[
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(labelText: 'Nama lengkap'),
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (_isLogin) {
                                  return null;
                                }
                                if (value == null || value.trim().isEmpty) {
                                  return 'Nama wajib diisi.';
                                }
                                if (value.trim().length < 3) {
                                  return 'Nama minimal 3 karakter.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(labelText: 'Email'),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              final email = value?.trim() ?? '';
                              final pattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                              if (email.isEmpty) {
                                return 'Email wajib diisi.';
                              }
                              if (!pattern.hasMatch(email)) {
                                return 'Format email belum valid.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                onPressed: () => setState(() => _showPassword = !_showPassword),
                                icon: Icon(
                                  _showPassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                              ),
                            ),
                            obscureText: !_showPassword,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) {
                              if (!_isLoading) {
                                _submit();
                              }
                            },
                            validator: (value) {
                              final password = value ?? '';
                              if (password.isEmpty) {
                                return 'Password wajib diisi.';
                              }
                              if (!_isLogin && password.length < 6) {
                                return 'Password minimal 6 karakter.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          StatusBadge(
                            label: _isLogin
                                ? 'Role routing aktif: customer, admin, courier'
                                : 'Hanya anon/public key yang dipakai di Flutter client',
                            icon: Icons.info_outline_rounded,
                            backgroundColor: colors.surfaceMuted,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _isLoading ? null : _submit,
                            child: _isLoading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : Text(_isLogin ? 'Masuk' : 'Daftar Sekarang'),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: _isLoading
                                ? null
                                : () => setState(() => _isLogin = !_isLogin),
                            child: Text(
                              _isLogin
                                  ? 'Belum punya akun? Daftar'
                                  : 'Sudah punya akun? Masuk',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
