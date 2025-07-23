import 'package:evently/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // ignore: non_constant_identifier_names
  static ThemeData CustomeLightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.backgroundWhite,

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      // shape: CircleBorder(side: BorderSide(width: 5, color: AppColors.white)),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundWhite,
      foregroundColor: AppColors.primary,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    ),
    primaryColor: AppColors.primary,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: AppColors.white,
      unselectedItemColor: AppColors.white,
      backgroundColor: AppColors.primary,
      type: BottomNavigationBarType.fixed,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.backgroundWhite.withValues(alpha: 0.7),
      hintStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.white.withValues(alpha: 0.7),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: AppColors.primary),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: AppColors.primary),
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    textTheme: TextTheme(
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.white,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.white,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.white,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppColors.white,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: AppColors.white,
      ),
    ),
  );

  // ignore: non_constant_identifier_names
  static ThemeData CustomeDarkTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.backgroundDark,
  );
}
