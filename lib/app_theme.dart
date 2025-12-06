import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundGradient[1],
      primaryColor: AppColors.accentColor,
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accentColor,
        secondary: AppColors.blobColor2,
        surface: Colors.transparent, // For glass effect
      ),
      useMaterial3: true,
    );
  }
}
