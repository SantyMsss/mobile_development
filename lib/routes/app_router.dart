import 'package:go_router/go_router.dart';
import '../views/home/home_screen.dart';
import '../views/details/details_screen.dart';
import '../views/ciclo_vida/ciclo_vida_screen.dart';
import '../views/research/research_categories_screen.dart';
import '../views/research/research_list_screen.dart';
import '../views/research/research_detail_screen.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/register_screen.dart';
import '../views/profile/profile_screen.dart';
import '../views/easysave/easysave_screen.dart';
import '../views/easysave/ingresos_screen.dart';
import '../views/easysave/gastos_screen.dart';
import '../services/storage_service.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/easysave',
  redirect: (context, state) async {
    final storage = StorageService();
    final isLoggedIn = await storage.isLoggedIn();
    final isGoingToLogin = state.matchedLocation == '/login';
    final isGoingToRegister = state.matchedLocation == '/register';

    // Si no está logueado y no va a login/register, redirigir a login
    if (!isLoggedIn && !isGoingToLogin && !isGoingToRegister) {
      return '/login';
    }

    // Si está logueado y va a login/register, redirigir a EasySave
    if (isLoggedIn && (isGoingToLogin || isGoingToRegister)) {
      return '/easysave';
    }

    return null; // No redirigir
  },
  routes: [
    // Rutas de autenticación (públicas)
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),

    // Ruta principal: EasySave Dashboard
    GoRoute(
      path: '/easysave',
      name: 'easysave',
      builder: (context, state) => const EasySaveScreen(),
    ),
    GoRoute(
      path: '/easysave/ingresos',
      name: 'ingresos',
      builder: (context, state) => const IngresosScreen(),
    ),
    GoRoute(
      path: '/easysave/gastos',
      name: 'gastos',
      builder: (context, state) => const GastosScreen(),
    ),

    // Rutas protegidas (requieren autenticación)
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
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
    GoRoute(
      path: '/research',
      name: 'research',
      builder: (context, state) => const ResearchCategoriesScreen(),
    ),
    GoRoute(
      path: '/research/:categoryId',
      name: 'research-list',
      builder: (context, state) {
        final categoryId = state.pathParameters['categoryId']!;
        final categoryName = state.uri.queryParameters['categoryName'] ?? 'Productos';
        final apiEndpoint = state.uri.queryParameters['apiEndpoint'] ?? '';
        return ResearchListScreen(
          categoryId: categoryId,
          categoryName: categoryName,
          apiEndpoint: apiEndpoint,
        );
      },
    ),
    GoRoute(
      path: '/research/:categoryId/:productId',
      name: 'research-detail',
      builder: (context, state) {
        final categoryId = state.pathParameters['categoryId']!;
        final productId = state.pathParameters['productId']!;
        final apiEndpoint = state.uri.queryParameters['apiEndpoint'] ?? '';
        return ResearchDetailScreen(
          categoryId: categoryId,
          productId: productId,
          apiEndpoint: apiEndpoint,
        );
      },
    ),
  ],
);

