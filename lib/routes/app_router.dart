import 'package:go_router/go_router.dart';
import '../views/home/home_screen.dart';
import '../views/details/details_screen.dart';
import '../views/ciclo_vida/ciclo_vida_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/details',
      builder: (context, state) {
        final name = state.uri.queryParameters['name'] ?? 'Ciclista';
        final from = state.uri.queryParameters['from'] ?? 'unknown';
        return DetailsScreen(name: name, from: from);
      },
    ),
    GoRoute(
      path: '/ciclo_vida',
      builder: (context, state) => const CicloVidaScreen(),
    ),
  ],
);
