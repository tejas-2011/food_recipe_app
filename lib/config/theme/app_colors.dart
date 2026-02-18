import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Colors - Olive Green palette
  static const Color primary = Color(0xFF556B2F); // Dark Olive Green
  static const Color primaryLight = Color(0xFF808B96);
  static const Color primaryDark = Color(0xFF3B4D20);

  // Secondary Colors - Earthy Gold/Sand
  static const Color secondary = Color(0xFFC2B280);
  static const Color secondaryLight = Color(0xFFD9CCA3);
  static const Color secondaryDark = Color(0xFFA6935C);

  // Accent Colors - Muted Terracotta
  static const Color accent = Color(0xFFBC8F8F);
  static const Color accentLight = Color(0xFFD4B4B4);
  static const Color accentDark = Color(0xFFA36B6B);

  // Neutral Colors
  static const Color background = Color(0xFFF9F9F4); // Slight off-white/cream
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F2EA);

  // Text Colors
  static const Color textPrimary = Color(0xFF2E3B19);
  static const Color textSecondary = Color(0xFF6B705C);
  static const Color textLight = Color(0xFFA5A58D);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Status Colors
  static const Color success = Color(0xFF6B9080);
  static const Color warning = Color(0xFFE9C46A);
  static const Color error = Color(0xFFE76F51);
  static const Color info = Color(0xFF457B9D);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const Color searchBarColor = Color(0xFFF0F2EA);
}