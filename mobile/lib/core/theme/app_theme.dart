import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FarmlyColors {
  FarmlyColors._();

  // Primary palette
  static const Color leafGreen = Color(0xFF3C8D40);
  static const Color warmAmber = Color(0xFFF5A623);
  static const Color deepTeal = Color(0xFF00695C);

  // Backgrounds
  static const Color background = Color(0xFFFAF9F6);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color lightGreenOverlay = Color(0xFFE8F5E9);
  static const Color lightAmberOverlay = Color(0xFFFFF8E1);
  static const Color lightTealOverlay = Color(0xFFE0F2F1);

  // Typography & Neutrals
  static const Color textPrimary = Color(0xFF2B2B2B);
  static const Color textSecondary = Color(0xFF6B6B68);
  static const Color border = Color(0xFFE4E2DA);

  // Status & Feedback
  static const Color alertRed = Color(0xFFC0533A);
  static const Color alertRedLight = Color(0xFFFFEBEE);
  static const Color successGreen = Color(0xFF7CB342);
  static const Color successGreenLight = Color(0xFFF1F8E9);
}

class FarmlyTheme {
  FarmlyTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: FarmlyColors.background,
      primaryColor: FarmlyColors.leafGreen,
      colorScheme: const ColorScheme.light(
        primary: FarmlyColors.leafGreen,
        secondary: FarmlyColors.warmAmber,
        tertiary: FarmlyColors.deepTeal,
        surface: FarmlyColors.cardBackground,
        error: FarmlyColors.alertRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: FarmlyColors.textPrimary,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.inter(
          color: FarmlyColors.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 28,
        ),
        displayMedium: GoogleFonts.inter(
          color: FarmlyColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
        titleLarge: GoogleFonts.inter(
          color: FarmlyColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
        titleMedium: GoogleFonts.inter(
          color: FarmlyColors.textPrimary,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        bodyLarge: GoogleFonts.inter(
          color: FarmlyColors.textPrimary,
          fontSize: 16,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.inter(
          color: FarmlyColors.textPrimary,
          fontSize: 14,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.inter(
          color: FarmlyColors.textSecondary,
          fontSize: 12,
        ),
      ),
      cardTheme: CardThemeData(
        color: FarmlyColors.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: FarmlyColors.border, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: GoogleFonts.inter(color: FarmlyColors.textSecondary, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: FarmlyColors.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: FarmlyColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: FarmlyColors.leafGreen, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: FarmlyColors.warmAmber,
          foregroundColor: FarmlyColors.textPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: FarmlyColors.deepTeal,
          side: const BorderSide(color: FarmlyColors.border, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: FarmlyColors.border,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
