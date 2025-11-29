import 'package:flutter/material.dart';

/// Modern minimalist theme configuration - Property listing inspired
class AppTheme {
  // Primary colors - Black and white focused
  static const Color primaryBlack = Color(0xFF000000);
  static const Color primaryWhite = Color(0xFFFFFFFF);

  // Gray scale
  static const Color lightGray = Color(0xFFF8F8F8); // Background
  static const Color mediumGray = Color(0xFFE0E0E0); // Unfilled tracks, borders
  static const Color darkGray = Color(0xFF666666); // Secondary text

  // Accent colors
  static const Color accentGreen = Color(0xFF22C55E); // Success/positive trend
  static const Color primaryBlue = Color(0xFF007AFF); // Legacy support
  static const Color secondaryBlue = Color(0xFF5AC8FA);
  static const Color successGreen = Color(
    0xFF22C55E,
  ); // Updated to match design
  static const Color warningOrange = Color(0xFFFF9500);
  static const Color errorRed = Color(0xFFFF3B30);

  // System grays (kept for compatibility)
  static const Color systemGray = Color(0xFF8E8E93);
  static const Color systemGray2 = Color(0xFFAEAEB2);
  static const Color systemGray3 = Color(0xFFC7C7CC);
  static const Color systemGray4 = Color(0xFFD1D1D6);
  static const Color systemGray5 = Color(0xFFE5E5EA);
  static const Color systemGray6 = Color(
    0xFFF8F8F8,
  ); // Updated to match lightGray

  // Labels
  static const Color label = Color(0xFF000000);
  static const Color secondaryLabel = Color(0xFF666666); // Updated to darkGray
  static const Color tertiaryLabel = Color(0x4D000000);

  // Border radius constants
  static const double borderRadiusSmall = 12.0;
  static const double borderRadiusMedium = 16.0;
  static const double borderRadiusLarge = 24.0;
  static const double borderRadiusXLarge = 32.0;

  /// Light theme - Modern minimalist design
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'SF Pro Display',
      colorScheme: ColorScheme.light(
        primary: primaryBlack,
        secondary: secondaryBlue,
        error: errorRed,
        surface: primaryWhite,
        onSurface: label,
        onPrimary: primaryWhite,
      ),
      scaffoldBackgroundColor: lightGray,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: lightGray,
        foregroundColor: label,
        titleTextStyle: TextStyle(
          color: label,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          fontFamily: 'SF Pro Display',
          letterSpacing: -0.4,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
        ),
        color: primaryWhite,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        shadowColor: Colors.black.withValues(alpha: 0.08),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primaryBlack,
          foregroundColor: primaryWhite,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusLarge),
          ),
          textStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            fontFamily: 'SF Pro Display',
            letterSpacing: -0.2,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryBlack,
          textStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            fontFamily: 'SF Pro Display',
            letterSpacing: -0.2,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: mediumGray.withValues(alpha: 0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusLarge),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        hintStyle: TextStyle(
          color: darkGray,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: mediumGray.withValues(alpha: 0.3),
        selectedColor: primaryBlack,
        labelStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusXLarge),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  /// Dark theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'SF Pro Display',
      colorScheme: ColorScheme.dark(
        primary: primaryBlue,
        secondary: secondaryBlue,
        error: errorRed,
        surface: const Color(0xFF1C1C1E),
        onSurface: Colors.white,
        onPrimary: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color(0xFF1C1C1E),
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          fontFamily: 'SF Pro Display',
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
        ),
        color: const Color(0xFF1C1C1E),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            fontFamily: 'SF Pro Display',
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryBlue,
          textStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            fontFamily: 'SF Pro Display',
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1C1C1E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
