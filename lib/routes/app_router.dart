import 'package:go_router/go_router.dart';
import '../views/home/home_screen_impl.dart';
import '../views/paso_parametros/paso_parametros_screen_impl.dart';

class AppRouter {
  static GoRouter get router => GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
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
}
