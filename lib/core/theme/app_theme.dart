import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.surface,
    required this.surfaceMuted,
    required this.surfaceSoft,
    required this.primary,
    required this.accent,
    required this.gold,
    required this.text,
    required this.mutedText,
    required this.outline,
    required this.success,
    required this.shadow,
  });

  final Color background;
  final Color surface;
  final Color surfaceMuted;
  final Color surfaceSoft;
  final Color primary;
  final Color accent;
  final Color gold;
  final Color text;
  final Color mutedText;
  final Color outline;
  final Color success;
  final Color shadow;

  @override
  AppColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceMuted,
    Color? surfaceSoft,
    Color? primary,
    Color? accent,
    Color? gold,
    Color? text,
    Color? mutedText,
    Color? outline,
    Color? success,
    Color? shadow,
  }) {
    return AppColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      surfaceSoft: surfaceSoft ?? this.surfaceSoft,
      primary: primary ?? this.primary,
      accent: accent ?? this.accent,
      gold: gold ?? this.gold,
      text: text ?? this.text,
      mutedText: mutedText ?? this.mutedText,
      outline: outline ?? this.outline,
      success: success ?? this.success,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }

    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      surfaceSoft: Color.lerp(surfaceSoft, other.surfaceSoft, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      gold: Color.lerp(gold, other.gold, t)!,
      text: Color.lerp(text, other.text, t)!,
      mutedText: Color.lerp(mutedText, other.mutedText, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      success: Color.lerp(success, other.success, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }
}

const _colors = AppColors(
  background: Color(0xFFF9FAFB),
  surface: Color(0xFFFFFFFF),
  surfaceMuted: Color(0xFFF3F4F6),
  surfaceSoft: Color(0xFFE5E7EB),
  primary: Color(0xFF111827),
  accent: Color(0xFFE11D48),
  gold: Color(0xFFF59E0B),
  text: Color(0xFF121C2A),
  mutedText: Color(0xFF5F6B7A),
  outline: Color(0xFFE5E7EB),
  success: Color(0xFF15803D),
  shadow: Color(0x12111827),
);

extension AppThemeX on BuildContext {
  AppColors get appColors =>
      Theme.of(this).extension<AppColors>() ?? _colors;
}

ThemeData buildTokoOliTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: _colors.primary,
    brightness: Brightness.light,
  ).copyWith(
    primary: _colors.primary,
    onPrimary: Colors.white,
    secondary: _colors.accent,
    onSecondary: Colors.white,
    tertiary: _colors.gold,
    surface: _colors.surface,
    onSurface: _colors.text,
    outline: _colors.outline,
    error: const Color(0xFFBA1A1A),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: _colors.background,
    cardColor: _colors.surface,
    dividerColor: _colors.outline,
    fontFamily: 'Inter',
    extensions: const [AppColors(
      background: Color(0xFFF9FAFB),
      surface: Color(0xFFFFFFFF),
      surfaceMuted: Color(0xFFF3F4F6),
      surfaceSoft: Color(0xFFE5E7EB),
      primary: Color(0xFF111827),
      accent: Color(0xFFE11D48),
      gold: Color(0xFFF59E0B),
      text: Color(0xFF121C2A),
      mutedText: Color(0xFF5F6B7A),
      outline: Color(0xFFE5E7EB),
      success: Color(0xFF15803D),
      shadow: Color(0x12111827),
    )],
    textTheme: const TextTheme(
      displaySmall: TextStyle(
        color: Color(0xFF121C2A),
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
      headlineMedium: TextStyle(
        color: Color(0xFF121C2A),
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
      headlineSmall: TextStyle(
        color: Color(0xFF121C2A),
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.25,
      ),
      titleLarge: TextStyle(
        color: Color(0xFF121C2A),
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      titleMedium: TextStyle(
        color: Color(0xFF121C2A),
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      bodyLarge: TextStyle(
        color: Color(0xFF121C2A),
        fontSize: 16,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        color: Color(0xFF5F6B7A),
        fontSize: 14,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        color: Color(0xFF778397),
        fontSize: 12,
        height: 1.4,
      ),
      labelLarge: TextStyle(
        color: Color(0xFF121C2A),
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
      labelMedium: TextStyle(
        color: Color(0xFF5F6B7A),
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: _colors.background,
      foregroundColor: _colors.text,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _colors.surface,
      hintStyle: const TextStyle(color: Color(0xFF7B8795)),
      prefixIconColor: _colors.mutedText,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: _colors.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: _colors.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: _colors.accent, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFFBA1A1A)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFFBA1A1A), width: 1.4),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: _colors.surfaceMuted,
      disabledColor: _colors.surfaceMuted,
      selectedColor: _colors.primary,
      side: BorderSide(color: _colors.outline),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      labelStyle: const TextStyle(
        color: Color(0xFF121C2A),
        fontWeight: FontWeight.w600,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _colors.accent,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _colors.primary,
        side: BorderSide(color: _colors.outline),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: _colors.surface,
      selectedItemColor: _colors.accent,
      unselectedItemColor: _colors.mutedText,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: _colors.primary,
      contentTextStyle: const TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      behavior: SnackBarBehavior.floating,
    ),
    dividerTheme: DividerThemeData(color: _colors.outline),
  );
}
