import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors FITCORE — dark premium theme
  static const Color primary = Color(0xFF7C3AED); // Purple
  static const Color primaryLight = Color(0xFFEC4899); // Pink
  static const Color accent = Color(0xFF06B6D4); // Cyan
  static const Color accentGreen = Color(0xFF84CC16); // Lime

  // Gradient utama
  static const List<Color> primaryGradient = [
    Color(0xFF7C3AED),
    Color(0xFFEC4899),
    Color(0xFFF97316),
  ];

  // Background
  static const Color background = Color(0xFF0A0A0F);
  static const Color surface = Color(0xFF1A1A2E);
  static const Color cardBg = Color(0x0FFFFFFF); // rgba 6%

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0x73FFFFFF); // rgba 45%
  static const Color textHint = Color(0x40FFFFFF);

  // Semantic
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);

  // Border glass
  static const Color borderGlass = Color(0x1FFFFFFF); // rgba 12%
}
