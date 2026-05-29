import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle get brandTitle => GoogleFonts.playfairDisplay(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  static TextStyle get headline => GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryDark,
  );

  static TextStyle get subtitle => GoogleFonts.poppins(
    fontSize: 13,
    color: AppColors.textSecondary,
    height: 1.6,
  );

  static TextStyle get label => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodySmall => GoogleFonts.poppins(
    fontSize: 13,
    color: AppColors.textSecondary,
  );

  static TextStyle get linkText => GoogleFonts.poppins(
    fontSize: 13,
    color: AppColors.primary,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get button => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // Tambahan untuk layar lain
  static TextStyle get navLabel => GoogleFonts.poppins(
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get sectionTitle => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryDark,
  );

  static TextStyle get cardTitle => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get cardSubtitle => GoogleFonts.poppins(
    fontSize: 12,
    color: AppColors.textSecondary,
  );
}
