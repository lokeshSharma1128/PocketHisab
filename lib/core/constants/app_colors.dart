import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  // Brand accent — always mint green
  static const Color accent    = Color(0xFF6EE7B7);
  static const Color accentDark = Color(0xFF34D399);

  // Semantic — same in both themes
  static const Color income      = Color(0xFF059669); // dark-friendly green
  static const Color expense     = Color(0xFFEF4444);
  static const Color warning     = Color(0xFFFBBF24);
  static const Color info        = Color(0xFF60A5FA);
  static const Color purple      = Color(0xFFA78BFA);

  // ── Dark palette ─────────────────────────────────────────────────────────
  static const Color darkBg       = Color(0xFF0E0F12);
  static const Color darkSurface  = Color(0xFF16181D);
  static const Color darkSurface2 = Color(0xFF1E2028);
  static const Color darkSurface3 = Color(0xFF252830);

  static const Color darkTextPrimary   = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextTertiary  = Color(0xFF475569);

  static const Color darkBorder = Color(0x12FFFFFF);

  // ── Light palette ─────────────────────────────────────────────────────────
  static const Color lightBg       = Color(0xFFF5F7FA);
  static const Color lightSurface  = Color(0xFFFFFFFF);
  static const Color lightSurface2 = Color(0xFFF0F2F5);
  static const Color lightSurface3 = Color(0xFFE8EBF0);

  static const Color lightTextPrimary   = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextTertiary  = Color(0xFF94A3B8);

  static const Color lightBorder = Color(0x1A000000);

  // ── Context-aware accessors ───────────────────────────────────────────────
  // Use these throughout widgets instead of hardcoded dark values.

  static Color bg(BuildContext context) =>
      _isDark(context) ? darkBg : lightBg;

  static Color surface(BuildContext context) =>
      _isDark(context) ? darkSurface : lightSurface;

  static Color surface2(BuildContext context) =>
      _isDark(context) ? darkSurface2 : lightSurface2;

  static Color surface3(BuildContext context) =>
      _isDark(context) ? darkSurface3 : lightSurface3;

  static Color textPrimary(BuildContext context) =>
      _isDark(context) ? darkTextPrimary : lightTextPrimary;

  static Color textSecondary(BuildContext context) =>
      _isDark(context) ? darkTextSecondary : lightTextSecondary;

  static Color textTertiary(BuildContext context) =>
      _isDark(context) ? darkTextTertiary : lightTextTertiary;

  static Color border(BuildContext context) =>
      _isDark(context) ? darkBorder : lightBorder;

  // Category colors — work fine on both themes
  static const List<Color> categoryColors = [
    Color(0xFFEF4444),
    Color(0xFFF97316),
    Color(0xFFF59E0B),
    Color(0xFF10B981),
    Color(0xFF3B82F6),
    Color(0xFF8B5CF6),
    Color(0xFFEC4899),
    Color(0xFF6B7280),
  ];

  static Color forCategory(int index) =>
      categoryColors[index % categoryColors.length];

  static bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;
}