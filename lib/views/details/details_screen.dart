import 'package:flutter/foundation.dart';
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
  List<String> logs = [];

  void _addLog(String log) {
    setState(() {
      logs.add("${DateTime.now().toString().substring(11, 19)} - $log");
      if (logs.length > 8) {
        logs.removeAt(0); // Mantener solo los últimos 8 logs
      }
    });
    if (kDebugMode) {
      print("========================================");
      print(log);
      print("========================================");
    }
  }

  @override
  void initState() {
    super.initState();
    
    // Mostrar parámetros recibidos en consola
    if (kDebugMode) {
      print("📥=== PARÁMETROS RECIBIDOS EN DETAILS ===");
      print("📦 Parámetros decodificados:");
      print("   • name: '${widget.name}'");
      print("   • from: '${widget.from}'");
      print("🎯 Método de navegación detectado: ${widget.from.toUpperCase()}");
      print("=======================================");
    }
    
    _addLog("🟢 DetailsScreen: initState() - Navegado con ${widget.from}");
    _addLog("📦 Parámetros: name='${widget.name}', from='${widget.from}'");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _addLog("🔵 DetailsScreen: didChangeDependencies() - Método: ${widget.from}");
  }

  @override
  Widget build(BuildContext context) {
    _addLog("🟡 DetailsScreen: build() - Construyendo UI para ${widget.name}");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Ciclista'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _goBack(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Información del Ciclista',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Nombre:', widget.name),
                    const SizedBox(height: 8),
                    _buildInfoRow('Navegación:', _getNavigationDescription(widget.from)),
                    const SizedBox(height: 8),
                    _buildInfoRow('Desde:', widget.from),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estadísticas de Carrera',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Etapas ganadas:', '3'),
                    const SizedBox(height: 8),
                    _buildInfoRow('Posición general:', '2º'),
                    const SizedBox(height: 8),
                    _buildInfoRow('Tiempo total:', '85h 23m 45s'),
                    const SizedBox(height: 8),
                    _buildInfoRow('Equipo:', 'Team Sky'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Logs del ciclo de vida
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.timeline, color: Colors.orange),
                        const SizedBox(width: 8),
                        Text(
                          'Ciclo de Vida - Navegación ${widget.from.toUpperCase()}',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 150,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: ListView.builder(
                        itemCount: logs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 1),
                            child: Text(
                              logs[index],
                              style: const TextStyle(
                                fontSize: 11,
                                fontFamily: 'monospace',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _goBack(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Volver al inicio'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  String _getNavigationDescription(String from) {
    switch (from) {
      case 'go':
        return 'Navegación con context.go()';
      case 'push':
        return 'Navegación con context.push()';
      case 'replace':
        return 'Navegación con context.pushReplacement()';
      default:
        return 'Navegación desconocida';
    }
  }

  void _goBack(BuildContext context) {
    _addLog("🔴 DetailsScreen: Navegando de vuelta - Método usado: ${widget.from}");
    
    // Si venimos de 'go' o 'replace', no podemos hacer pop, así que vamos al home
    if (widget.from == 'go' || widget.from == 'replace') {
      context.go('/');
    } else {
      // Si venimos de 'push', podemos hacer pop
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/');
      }
    }
  }

  @override
  void dispose() {
    _addLog("🔴 DetailsScreen: dispose() - Liberando recursos");
    super.dispose();
  }
}