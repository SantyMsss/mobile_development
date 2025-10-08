import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/research_product.dart';
import '../../services/web_research_api_service.dart';
import '../../widgets/base_view.dart';

class ResearchDetailScreen extends StatefulWidget {
  final String categoryId;
  final String productId;
  final String apiEndpoint;

  const ResearchDetailScreen({
    super.key,
    required this.categoryId,
    required this.productId,
    required this.apiEndpoint,
  });

  @override
  State<ResearchDetailScreen> createState() => _ResearchDetailScreenState();
}

class _ResearchDetailScreenState extends State<ResearchDetailScreen> {
  ResearchProduct? product;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final fetchedProduct = await WebResearchApiService.getResearchProductById(
        widget.productId,
        widget.apiEndpoint,
      );
      
      setState(() {
        product = fetchedProduct;
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
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Detalle del Producto',
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
            Text('Cargando información detallada...'),
          ],
        ),
      );
    }

    if (errorMessage != null || product == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Producto no encontrado',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'No se pudo encontrar la información del producto seleccionado.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Volver'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título principal
          Text(
            product!.titulo,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Información básica
          _InfoCard(
            title: 'Información General',
            children: [
              if (product!.autores != null)
                _InfoRow(
                  icon: Icons.person,
                  label: 'Autores',
                  value: product!.autores!,
                ),
              if (product!.fechaPublicacion != null)
                _InfoRow(
                  icon: Icons.calendar_today,
                  label: 'Fecha de Publicación',
                  value: product!.fechaPublicacion!,
                ),
              if (product!.revista != null)
                _InfoRow(
                  icon: Icons.book,
                  label: 'Revista/Editorial',
                  value: product!.revista!,
                ),
              if (product!.volumen != null)
                _InfoRow(
                  icon: Icons.numbers,
                  label: 'Volumen',
                  value: product!.volumen!,
                ),
              if (product!.paginas != null)
                _InfoRow(
                  icon: Icons.pages,
                  label: 'Páginas',
                  value: product!.paginas!,
                ),
              _InfoRow(
                icon: Icons.category,
                label: 'Tipología',
                value: product!.tipologia,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Descripción/Resumen
          if (product!.descripcion != null || product!.resumen != null)
            _InfoCard(
              title: 'Descripción',
              children: [
                Text(
                  product!.descripcion ?? product!.resumen ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ],
            ),

          const SizedBox(height: 16),

          // Información adicional
          _InfoCard(
            title: 'Información Adicional',
            children: [
              if (product!.doi != null)
                _InfoRow(
                  icon: Icons.link,
                  label: 'DOI',
                  value: product!.doi!,
                ),
              if (product!.url != null)
                _InfoRow(
                  icon: Icons.web,
                  label: 'URL',
                  value: product!.url!,
                  isLink: true,
                ),
              if (product!.keywords != null)
                _InfoRow(
                  icon: Icons.label,
                  label: 'Palabras Clave',
                  value: product!.keywords!,
                ),
              _InfoRow(
                icon: Icons.fingerprint,
                label: 'ID',
                value: product!.id,
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Botón volver
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Volver al Listado'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _InfoCard({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLink;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLink = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: isLink ? Colors.blue : Colors.black87,
                    decoration: isLink ? TextDecoration.underline : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}