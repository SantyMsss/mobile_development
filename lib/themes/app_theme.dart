import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFE60000),
        primary: const Color(0xFFE60000),
        secondary: const Color(0xFF007AFF),
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFE60000),
        foregroundColor: Colors.white,
      ),
    );
  }
}
