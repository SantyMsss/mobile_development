import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DetailsScreen extends StatefulWidget {
  final String name;
  final String from;

  const DetailsScreen({
    super.key,
    required this.name,
    required this.from,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    print('🟢 DetailsScreen: initState() - Pantalla de detalles inicializada');
    print('   - Nombre recibido: ${widget.name}');
    print('   - Método de navegación: ${widget.from}');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('🔵 DetailsScreen: didChangeDependencies() - Dependencias cargadas');
  }

  @override
  Widget build(BuildContext context) {
    print('🟡 DetailsScreen: build() - Construyendo pantalla de detalles');
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de Ciclista'),
        backgroundColor: const Color(0xFFE60000),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: _shouldShowBackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información de parámetros recibidos
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Información del Ciclista:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow('Nombre:', widget.name),
                    _buildInfoRow('Método de navegación:', widget.from),
                    _buildInfoRow('Estado:', _counter == 0 ? 'Descansando' : 'Pedaleando ($_counter km)'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Explicación de diferencias de navegación
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tipo de Navegación:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    _buildNavigationExplanation(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Stack con imagen y texto superpuesto
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      "https://cdn.sanity.io/images/cwkbno5g/production/f9acfa7347d0cf1d1653a15f11883466f6d357d2-6018x4148.jpg?w=1600&quality=80&auto=format&fit=min",
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.image, size: 50),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Ciclista en Acción',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _counter == 0 ? 'Listo para comenzar' : 'Distancia: $_counter km',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Botones de acción
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _incrementCounter,
                  icon: const Icon(Icons.add),
                  label: const Text('Añadir Km'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/');
                    }
                  },
                  icon: const Icon(Icons.home),
                  label: const Text('Regresar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE60000),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildNavigationExplanation() {
    switch (widget.from) {
      case 'go':
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• GO: Como cambiar de carrera completa'),
            Text('• No hay botón "atrás" automático'),
            Text('• Útil para navegación entre pantallas principales'),
          ],
        );
      case 'push':
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• PUSH: Como añadir una etapa al recorrido'),
            Text('• Mantiene el botón "atrás"'),
            Text('• Permite regresar a la pantalla anterior'),
          ],
        );
      case 'replace':
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• REPLACE: Como cambiar el tipo de carrera'),
            Text('• No hay botón "atrás" para la pantalla reemplazada'),
            Text('• Útil para flows donde no se debe regresar'),
          ],
        );
      default:
        return const Text('Navegación desde el menú principal');
    }
  }

  bool _shouldShowBackButton() {
    return widget.from == 'push' || context.canPop();
  }

  void _incrementCounter() {
    print('🔴 DetailsScreen: setState() - Incrementando contador, ejecutará build()');
    
    setState(() {
      _counter += 5;
    });
  }

  @override
  void dispose() {
    print('🔴 DetailsScreen: dispose() - Pantalla de detalles siendo eliminada');
    super.dispose();
  }
}