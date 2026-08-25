import 'package:flutter/material.dart';

class AppTheme {
  // Main Colors
  static const Color primary = Color(0xFF18212F);
  static const Color secondary = Color(0xFF287C8E);
  static const Color purple = Color(0xFF7564A8);
  static const Color accent = Color(0xFFE56B6F);
  static const Color success = Color(0xFF5B9279);
  static const Color rating = Color(0xFFF2B84B);

  // Background & Surface
  static const Color background = Color(0xFFF4F7F9);
  static const Color card = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF18212F);
  static const Color textSecondary = Color(0xFF687583);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    scaffoldBackgroundColor: background,

    colorScheme: ColorScheme.fromSeed(
      seedColor: secondary,
      brightness: Brightness.light,
    ).copyWith(
      primary: secondary,
      secondary: purple,
      surface: card,
      error: accent,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
    ),

    cardTheme: CardThemeData(
      color: card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: secondary,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(
          double.infinity,
          54,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,

      hintStyle: const TextStyle(
        color: textSecondary,
      ),

      prefixIconColor: secondary,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: secondary.withValues(alpha: 0.45),
          width: 1.2,
        ),
      ),
    ),
  );
}