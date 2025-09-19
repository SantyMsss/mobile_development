import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';
import 'screens/details_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // Configuración de go_router
  final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      // Ruta principal
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      // Ruta secundaria con parámetros
      GoRoute(
        path: '/details',
        builder: (context, state) {
          final name = state.uri.queryParameters['name'] ?? 'Ciclista';
          final from = state.uri.queryParameters['from'] ?? 'unknown';
          return DetailsScreen(name: name, from: from);
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mundial 2024 - Mundial de Ciclismo',
      debugShowCheckedModeBanner: false,
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
    );
  }
}