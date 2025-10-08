import 'package:go_router/go_router.dart';
import '../views/home/home_screen.dart';
import '../views/details/details_screen.dart';
import '../views/ciclo_vida/ciclo_vida_screen.dart';
import '../views/research/research_categories_screen.dart';
import '../views/research/research_list_screen.dart';
import '../views/research/research_detail_screen.dart';

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
