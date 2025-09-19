import 'package:flutter/material.dart';
// Imports centralizados (router y theme)
import 'routes/app_router.dart';
import 'themes/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Use centralized router from routes/app_router.dart
  static final router = AppRouter.router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mundial 2024 - Mundial de Ciclismo',
      debugShowCheckedModeBanner: false,
<<<<<<< HEAD
      theme: AppTheme.theme,
      routerConfig: router,
=======
      theme: ThemeData(
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
      ),
      routerConfig: _router,
>>>>>>> abdcbb7df1cc59d58c16b5f5cef2cb1510ccb09f
    );
  }
}