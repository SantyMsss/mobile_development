import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final String studentName;

  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.studentName,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, // Para mostrar 4 elementos
      currentIndex: currentIndex,
      onTap: (index) {
        onTap(index);
        switch (index) {
          case 0:
            // Inicio - ya estamos ahí
            break;
          case 1:
            // Navegar a detalles con el nombre del estudiante
            final url = '/details?name=${Uri.encodeComponent(studentName)}&from=navbar';
            if (kDebugMode) {
              print("🚀=== NAVEGACIÓN DESDE NAVBAR ===");
              print("📦 Parámetros siendo pasados:");
              print("   • name: '$studentName'");
              print("   • from: 'navbar'");
              print("🌐 URL completa: '$url'");
              print("⚡ Método: context.push() - Desde barra de navegación");
              print("================================");
            }
            context.push(url);
            break;
          case 2:
            // Navegar a Future View
            if (kDebugMode) {
              print("🚀=== NAVEGACIÓN A FUTURE VIEW ===");
              print("🌐 URL: '/future'");
              print("⚡ Método: context.push() - Future async/await demo");
              print("================================");
            }
            context.push('/future');
            break;
          case 3:
            // Mostrar información de configuración
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("⚙️ Configuración del Mundial 2024 - Desarrollado con Flutter"),
                duration: Duration(seconds: 3),
                backgroundColor: Colors.blue,
              ),
            );
            break;
        }
      },
      selectedItemColor: const Color(0xFFE60000),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.navigate_next), label: 'Navegar'),
        BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Future'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Config'),
      ],
    );
  }
}
