import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/research_product.dart';
import '../../services/web_research_api_service.dart';

class ResearchListScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final String apiEndpoint;

  const ResearchListScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.apiEndpoint,
  });

  @override
  State<ResearchListScreen> createState() => _ResearchListScreenState();
}

class _ResearchListScreenState extends State<ResearchListScreen> {
  List<ResearchProduct> products = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final loadedProducts = await WebResearchApiService.getResearchProducts(widget.apiEndpoint);
      setState(() {
        products = loadedProducts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString().replaceFirst('ApiException: ', '');
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $errorMessage'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Reintentar',
              textColor: Colors.white,
              onPressed: _loadProducts,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Cargando productos de investigación...'),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error al cargar datos',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadProducts,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.info_outline, size: 64, color: Colors.blue),
            const SizedBox(height: 16),
            Text(
              'Sin información disponible',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'No se encontraron productos de investigación para esta categoría en este momento.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadProducts,
              icon: const Icon(Icons.refresh),
              label: const Text('Actualizar'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadProducts,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${products.length} productos encontrados',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(
                    product: product,
                    onTap: () {
                      context.pushNamed(
                        'research-detail',
                        pathParameters: {
                          'categoryId': widget.categoryId,
                          'productId': product.id,
                        },
                        queryParameters: {
                          'apiEndpoint': widget.apiEndpoint,
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final ResearchProduct product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getTypeColor(product.tipologia),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        _getTypeIcon(product.tipologia),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.titulo,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getTypeName(product.tipologia),
                          style: TextStyle(
                            color: _getTypeColor(product.tipologia),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (product.autores != null) ...[
                Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        product.autores!,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
              ],
              _buildSpecificInfo(),
              if (product.fechaPublicacion != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      product.fechaPublicacion!,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecificInfo() {
    switch (product.tipologia) {
      case 'ART_I':
      case 'ART_E':
        return _buildArticleInfo();
      case 'LIB':
        return _buildBookInfo();
      case 'CAP_LIB':
        return _buildChapterInfo();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildArticleInfo() {
    return Column(
      children: [
        if (product.revista != null) ...[
          Row(
            children: [
              const Icon(Icons.article, size: 16, color: Colors.blue),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  product.revista!,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
        Row(
          children: [
            if (product.volumen != null) ...[
              const Icon(Icons.numbers, size: 16, color: Colors.orange),
              const SizedBox(width: 4),
              Text(
                'Vol. ${product.volumen}',
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 12),
            ],
            if (product.paginas != null && product.paginas!.isNotEmpty) ...[
              const Icon(Icons.description, size: 16, color: Colors.green),
              const SizedBox(width: 4),
              Text(
                'Pág. ${product.paginas}',
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildBookInfo() {
    return Column(
      children: [
        if (product.revista != null) ...[
          Row(
            children: [
              const Icon(Icons.business, size: 16, color: Colors.purple),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  product.revista!,
                  style: const TextStyle(
                    color: Colors.purple,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
      ],
    );
  }

  Widget _buildChapterInfo() {
    return Column(
      children: [
        if (product.revista != null) ...[
          Row(
            children: [
              const Icon(Icons.menu_book, size: 16, color: Colors.indigo),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Libro: ${product.revista!}',
                  style: const TextStyle(
                    color: Colors.indigo,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
      ],
    );
  }

  Color _getTypeColor(String tipologia) {
    switch (tipologia) {
      case 'ART_I':
        return Colors.red.shade300;
      case 'ART_E':
        return Colors.blue.shade300;
      case 'LIB':
        return Colors.green.shade300;
      case 'CAP_LIB':
        return Colors.orange.shade300;
      default:
        return Colors.grey.shade300;
    }
  }

  String _getTypeIcon(String tipologia) {
    switch (tipologia) {
      case 'ART_I':
        return '📰';
      case 'ART_E':
        return '💻';
      case 'LIB':
        return '📚';
      case 'CAP_LIB':
        return '📖';
      default:
        return '📄';
    }
  }

  String _getTypeName(String tipologia) {
    switch (tipologia) {
      case 'ART_I':
        return 'ARTÍCULO IMPRESO';
      case 'ART_E':
        return 'ARTÍCULO ELECTRÓNICO';
      case 'LIB':
        return 'LIBRO DE INVESTIGACIÓN';
      case 'CAP_LIB':
        return 'CAPÍTULO DE LIBRO';
      default:
        return 'PRODUCTO DE INVESTIGACIÓN';
    }
  }
}