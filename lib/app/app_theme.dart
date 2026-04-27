import 'package:flutter/material.dart';

const _background = Color(0xFF101417);
const _surface = Color(0xFF1C2024);
const _surfaceHigh = Color(0xFF262A2E);
const _surfaceHigher = Color(0xFF313539);
const _primary = Color(0xFFFF6B00);
const _primarySoft = Color(0xFFFFB693);
const _outline = Color(0xFF5A4136);
const _text = Color(0xFFE0E3E8);
const _muted = Color(0xFFA98A7D);

ThemeData buildTokoOliTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: _primary,
    brightness: Brightness.dark,
  ).copyWith(
    primary: _primary,
    secondary: const Color(0xFFC6C6C6),
    surface: _surface,
    onSurface: _text,
    outline: _outline,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: _background,
    cardColor: _surface,
    dividerColor: _outline,
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        color: _text,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
      headlineSmall: TextStyle(
        color: _text,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: TextStyle(
        color: _text,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        color: _text,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: _text,
        fontSize: 16,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        color: Color(0xFFC6C6C9),
        fontSize: 14,
        height: 1.5,
      ),
      labelLarge: TextStyle(
        color: _text,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.4,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _background,
      foregroundColor: _text,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _surface,
      hintStyle: const TextStyle(color: _muted),
      prefixIconColor: _muted,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: _outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: _outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: _primary, width: 1.4),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: _surfaceHigh,
      disabledColor: _surfaceHigh,
      selectedColor: _primary,
      side: const BorderSide(color: _outline),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      labelStyle: const TextStyle(color: _text, fontWeight: FontWeight.w600),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primary,
        foregroundColor: Colors.black,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: _surface,
      selectedItemColor: _primarySoft,
      unselectedItemColor: _muted,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w700),
      type: BottomNavigationBarType.fixed,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: _surfaceHigher,
      contentTextStyle: const TextStyle(color: _text),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
