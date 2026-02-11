import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme() {
    final base = ThemeData.light();
    final colorScheme = ColorScheme.fromSeed(seedColor: Colors.deepPurple);

    return ThemeData.from(
      colorScheme: colorScheme,
      useMaterial3: true,
    ).copyWith(
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 16.0,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        ),
      ),
      scaffoldBackgroundColor: Colors.grey.shade50,
      cardTheme: base.cardTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
      ),
    );
  }
}
