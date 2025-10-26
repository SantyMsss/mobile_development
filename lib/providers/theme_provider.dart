import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider para gestionar el tema de la aplicación (modo claro/oscuro)
/// Usa SharedPreferences para persistir la preferencia del usuario
class ThemeProvider extends ChangeNotifier {
  static const String _keyThemeMode = 'theme_mode';
  ThemeMode _themeMode = ThemeMode.light;

  ThemeProvider() {
    _loadThemeMode();
  }

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Cargar el tema guardado desde SharedPreferences
  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool(_keyThemeMode) ?? false;
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      print('🎨 Tema cargado: ${isDark ? "Oscuro" : "Claro"}');
      notifyListeners();
    } catch (e) {
      print('❌ Error cargando tema: $e');
    }
  }

  /// Cambiar el tema y guardarlo en SharedPreferences
  Future<void> toggleTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
      await prefs.setBool(_keyThemeMode, _themeMode == ThemeMode.dark);
      print('🎨 Tema cambiado a: ${_themeMode == ThemeMode.dark ? "Oscuro" : "Claro"}');
      notifyListeners();
    } catch (e) {
      print('❌ Error guardando tema: $e');
    }
  }

  /// Establecer tema específico
  Future<void> setThemeMode(ThemeMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _themeMode = mode;
      await prefs.setBool(_keyThemeMode, mode == ThemeMode.dark);
      print('🎨 Tema establecido: ${mode == ThemeMode.dark ? "Oscuro" : "Claro"}');
      notifyListeners();
    } catch (e) {
      print('❌ Error estableciendo tema: $e');
    }
  }

  /// Tema claro de la aplicación
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
      ),
    );
  }

  /// Tema oscuro de la aplicación
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
      ),
    );
  }
}
