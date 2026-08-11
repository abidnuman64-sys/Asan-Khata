import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF059669);
  static const Color primaryDark = Color(0xFF0F766E);
  static const Color primaryLight = Color(0xFFECFDF5);
  
  static const Color gaveRed = Color(0xFFDC2626);
  static const Color gaveRedLight = Color(0xFFFEF2F2);
  
  static const Color gotGreen = Color(0xFF16A34A);
  static const Color gotGreenLight = Color(0xFFF0FDF4);
  
  static const Color bgLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Colors.white;
  static const Color textMainLight = Color(0xFF0F172A);
  static const Color textMutedLight = Color(0xFF64748B);
  static const Color borderLight = Color(0xFFE2E8F0);

  // Dark Mode Colors
  static const Color bgDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color textMainDark = Color(0xFFF8FAFC);
  static const Color textMutedDark = Color(0xFF94A3B8);
  static const Color borderDark = Color(0xFF334155);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.bgLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.primaryDark,
        surface: AppColors.surfaceLight,
      ),
      textTheme: GoogleFonts.notoSansArabicTextTheme().apply(
        bodyColor: AppColors.textMainLight,
        displayColor: AppColors.textMainLight,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceLight,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.textMainLight),
        titleTextStyle: GoogleFonts.notoSansArabic(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textMainLight,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.borderLight),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.bgDark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        primary: AppColors.primary,
        surface: AppColors.surfaceDark,
      ),
      textTheme: GoogleFonts.notoSansArabicTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: AppColors.textMainDark,
        displayColor: AppColors.textMainDark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.textMainDark),
        titleTextStyle: GoogleFonts.notoSansArabic(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textMainDark,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.borderDark),
        ),
      ),
    );
  }
}
