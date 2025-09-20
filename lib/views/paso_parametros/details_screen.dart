import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DetalleScreen extends StatelessWidget {
  final String parametro;
  final String metodoNavegacion;

  const DetalleScreen({
    super.key,
    required this.parametro,
    required this.metodoNavegacion,
  });

  void _volverAtras(BuildContext context) {
    if (metodoNavegacion == 'push') {
      context.pop();
    } else {
      context.go('/paso_parametros');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detalles de Ciclista")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Parámetro recibido: $parametro",
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Text("Método de navegación: $metodoNavegacion"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _volverAtras(context),
              child: const Text("Volver"),
            ),
          ],
        ),
      ),
    );
  }
}
