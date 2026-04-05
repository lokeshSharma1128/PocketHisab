import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

class AppTheme {
  // ── Shared text-theme factory ─────────────────────────────────────────────
  static TextTheme _textTheme(Color primary, Color secondary, Color tertiary) {
    return GoogleFonts.dmSansTextTheme(
      TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w400, color: primary, letterSpacing: -1),
        displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: primary, letterSpacing: -0.5),
        headlineLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: primary),
        headlineMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: primary),
        titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: primary),
        titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: primary),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: primary),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: secondary),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: secondary),
        labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: tertiary, letterSpacing: 1.2),
      ),
    );
  }

  // ── Shared input decoration ───────────────────────────────────────────────
  static InputDecorationTheme _inputTheme(Color fill, Color border) {
    return InputDecorationTheme(
      filled: true,
      fillColor: fill,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: border, width: 0.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: border, width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.accent, width: 1),
      ),
      labelStyle: TextStyle(color: AppColors.darkTextSecondary),
      hintStyle: TextStyle(color: AppColors.darkTextTertiary),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  DARK THEME
  // ═══════════════════════════════════════════════════════════════════════════
  static ThemeData get darkTheme {
    const bg       = AppColors.darkBg;
    const surface  = AppColors.darkSurface;
    const surface3 = AppColors.darkSurface3;
    const primary  = AppColors.darkTextPrimary;
    const secondary = AppColors.darkTextSecondary;
    const tertiary  = AppColors.darkTextTertiary;
    const border    = AppColors.darkBorder;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        secondary: AppColors.accentDark,
        surface: surface,
        error: AppColors.expense,
      ),
      textTheme: _textTheme(primary, secondary, tertiary),
      appBarTheme: const AppBarTheme(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: false,
        foregroundColor: primary,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: AppColors.darkSurface,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: primary),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: border, width: 0.5),
        ),
      ),
      inputDecorationTheme: _inputTheme(surface3, border),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: bg,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: tertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      dividerTheme: const DividerThemeData(color: border, thickness: 0.5),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkSurface2,
        contentTextStyle: const TextStyle(color: primary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.darkSurface2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((s) =>
        s.contains(MaterialState.selected) ? AppColors.accent : tertiary),
        trackColor: MaterialStateProperty.resolveWith((s) =>
        s.contains(MaterialState.selected)
            ? AppColors.accent.withOpacity(0.4)
            : surface3),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  LIGHT THEME
  // ═══════════════════════════════════════════════════════════════════════════
  static ThemeData get lightTheme {
    const bg        = AppColors.lightBg;
    const surface   = AppColors.lightSurface;
    const surface3  = AppColors.lightSurface3;
    const primary   = AppColors.lightTextPrimary;
    const secondary = AppColors.lightTextSecondary;
    const tertiary  = AppColors.lightTextTertiary;
    const border    = AppColors.lightBorder;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: bg,
      colorScheme: const ColorScheme.light(
        primary: AppColors.accent,
        secondary: AppColors.accentDark,
        surface: surface,
        error: AppColors.expense,
      ),
      textTheme: _textTheme(primary, secondary, tertiary),
      appBarTheme: const AppBarTheme(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: false,
        foregroundColor: primary,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.lightSurface,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: primary),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: border, width: 0.5),
        ),
      ),
      inputDecorationTheme: _inputTheme(surface3, border),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.lightTextPrimary,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: tertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      dividerTheme: const DividerThemeData(color: border, thickness: 0.5),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.lightSurface,
        contentTextStyle: const TextStyle(color: primary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((s) =>
        s.contains(MaterialState.selected) ? AppColors.accent : tertiary),
        trackColor: MaterialStateProperty.resolveWith((s) =>
        s.contains(MaterialState.selected)
            ? AppColors.accent.withOpacity(0.35)
            : surface3),
      ),
    );
  }
}
