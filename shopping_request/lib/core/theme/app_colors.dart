import 'package:flutter/material.dart';

/// Shared colour palette. Keep this the single source of truth so every
/// member's screens stay visually consistent - don't hardcode hex values
/// in feature code, reference these instead.
class AppColors {
  AppColors._();

  static const Color forest = Color(0xFF1F3D2B); // headers, primary text on light
  static const Color leaf = Color(0xFF4C9A5A); // CTAs, active states
  static const Color leafDark = Color(0xFF33693F);
  static const Color leafLight = Color(0xFFE1EEE0); // chips, tinted cards

  static const Color citrus = Color(0xFFF2B705); // ratings, highlights
  static const Color tomato = Color(0xFFE8543E); // sale badges, errors, favourites

  static const Color cream = Color(0xFFFBF8F3); // light background
  static const Color charcoal = Color(0xFF2B2B26); // body text
  static const Color mist = Color(0xFFE4E1D6); // hairline borders
  static const Color mistFill = Color(0xFFF1EEE5); // placeholder image fill
  static const Color greyText = Color(0xFF8C8A7E); // secondary text

  // Dark mode surfaces
  static const Color darkBg = Color(0xFF14201A);
  static const Color darkSurface = Color(0xFF1C2A22);
  static const Color darkBorder = Color(0xFF2D3D33);
}
