import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Central theme definition. Screens should pull styles from
/// Theme.of(context) rather than redefining TextStyles/colours locally.
class AppTheme {
  AppTheme._();

  static TextTheme _textTheme(Color body, Color heading) {
    final display = GoogleFonts.spaceGrotesk(color: heading, fontWeight: FontWeight.w500);
    final text = GoogleFonts.inter(color: body);
    return TextTheme(
      displayLarge: display.copyWith(fontSize: 30),
      displayMedium: display.copyWith(fontSize: 26),
      displaySmall: display.copyWith(fontSize: 22),
      headlineMedium: display.copyWith(fontSize: 20),
      headlineSmall: display.copyWith(fontSize: 17),
      titleMedium: text.copyWith(fontSize: 15, fontWeight: FontWeight.w500),
      bodyLarge: text.copyWith(fontSize: 15),
      bodyMedium: text.copyWith(fontSize: 13),
      bodySmall: text.copyWith(fontSize: 12, color: AppColors.greyText),
      labelLarge: display.copyWith(fontSize: 15),
    );
  }

  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.cream,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.leaf,
        secondary: AppColors.citrus,
        error: AppColors.tomato,
        surface: Colors.white,
      ),
      textTheme: _textTheme(AppColors.charcoal, AppColors.forest),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.cream,
        foregroundColor: AppColors.charcoal,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.leaf,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(54),
          shape: const StadiumBorder(),
          textStyle: GoogleFonts.spaceGrotesk(fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.mist),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.mist),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.leaf, width: 1.4),
        ),
        hintStyle: GoogleFonts.inter(color: AppColors.greyText, fontSize: 14),
      ),
      dividerColor: AppColors.mist,
      useMaterial3: true,
    );
  }

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.darkBg,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.leaf,
        secondary: AppColors.citrus,
        error: AppColors.tomato,
        surface: AppColors.darkSurface,
      ),
      textTheme: _textTheme(Colors.white70, Colors.white),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBg,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.leaf,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(54),
          shape: const StadiumBorder(),
          textStyle: GoogleFonts.spaceGrotesk(fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.leaf, width: 1.4),
        ),
        hintStyle: GoogleFonts.inter(color: Colors.white38, fontSize: 14),
      ),
      dividerColor: AppColors.darkBorder,
      useMaterial3: true,
    );
  }
}
