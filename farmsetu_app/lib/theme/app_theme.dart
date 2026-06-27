import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  // ── Brand (never changes) ─────────────────────────────────
  static const primaryGreen = Color(0xFF4CAF50);
  static const starYellow = Color(0xFFFFB300);
  static const error = Color(0xFFEF5350);
  static const info = Color(0xFF42A5F5);

  // ── Dark palette ──────────────────────────────────────────
  static const background = Color(0xFF0D0D0D);
  static const surface = Color(0xFF141414);
  static const cardBg = Color(0xFF1A1A1A);
  static const surfaceHigh = Color(0xFF242424);
  static const divider = Color(0xFF2C2C2C);
  static const textPrimary = Color(0xFFF5F5F5);
  static const textSecondary = Color(0xFF9E9E9E);
  static const textMuted = Color(0xFF616161);

  // ── Light palette ─────────────────────────────────────────
  static const lBackground = Color(0xFFF5F7F5);
  static const lSurface = Color(0xFFFFFFFF);
  static const lCardBg = Color(0xFFFFFFFF);
  static const lSurfaceHigh = Color(0xFFEEF1EE);
  static const lDivider = Color(0xFFDDE3DD);
  static const lTextPrimary = Color(0xFF1A1A1A);
  static const lTextSecondary = Color(0xFF5A6A5A);
  static const lTextMuted = Color(0xFF9AAA9A);

  static ThemeData get darkTheme => _build(Brightness.dark);
  static ThemeData get lightTheme => _build(Brightness.light);

  static ThemeData _build(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final bg = dark ? background : lBackground;
    final surf = dark ? surface : lSurface;
    final card = dark ? cardBg : lCardBg;
    final surfH = dark ? surfaceHigh : lSurfaceHigh;
    final div = dark ? divider : lDivider;
    final txtPri = dark ? textPrimary : lTextPrimary;
    final txtSec = dark ? textSecondary : lTextSecondary;
    final base = dark ? ThemeData.dark() : ThemeData.light();

    return base.copyWith(
      scaffoldBackgroundColor: bg,
      colorScheme: base.colorScheme.copyWith(
        primary: primaryGreen,
        secondary: primaryGreen,
        surface: surf,
        error: error,
      ),
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
        bodyColor: txtPri,
        displayColor: txtPri,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        elevation: 0,
        titleTextStyle: GoogleFonts.inter(
            color: txtPri, fontSize: 18, fontWeight: FontWeight.w700),
        iconTheme: IconThemeData(color: txtPri),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: bg,
        selectedItemColor: primaryGreen,
        unselectedItemColor: txtSec,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle:
            GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 11),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfH,
        hintStyle: TextStyle(color: txtSec, fontSize: 14),
        labelStyle: TextStyle(color: txtSec, fontSize: 14),
        prefixIconColor: txtSec,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: div),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: div),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryGreen, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: error),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle:
              GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700),
          elevation: 0,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dividerTheme: DividerThemeData(color: div, space: 1),
      cardColor: card,
      // ← Register AppColors so every widget can access c.textPrimary etc.
      extensions: [dark ? AppColors.dark : AppColors.light],
    );
  }
}
