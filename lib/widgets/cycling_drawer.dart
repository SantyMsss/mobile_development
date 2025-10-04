import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CyclingDrawer extends StatelessWidget {
  const CyclingDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header del drawer con temática ciclista
          Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE60000), Color(0xFF007AFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const SafeArea(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.pedal_bike,
                      size: 60,
                      color: Colors.white,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Mundial 2024',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Ciclismo de Ruta',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Lista de opciones del menú
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.home,
                  title: 'Inicio',
                  subtitle: 'Pantalla principal',
                  route: '/',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.person,
                  title: 'Perfil',
                  subtitle: 'Información personal',
                  route: '/details?name=Santiago Martinez Serna&from=drawer',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.timeline,
                  title: 'Paso de Parámetros',
                  subtitle: 'Navegación con datos',
                  route: '/details?name=Demo Parámetros&from=drawer',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.refresh,
                  title: 'Ciclo de Vida',
                  subtitle: 'Estados del widget',
                  route: '/ciclo_vida',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.schedule,
                  title: 'Future',
                  subtitle: 'Async/await y ciclistas',
                  route: '/future',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.timer,
                  title: 'Timer',
                  subtitle: 'Cronómetro de entrenamiento',
                  route: '/timer',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.psychology,
                  title: 'Isolate',
                  subtitle: 'Procesamiento paralelo',
                  route: '/isolate',
                ),
                const Divider(),
                _buildDrawerItem(
                  context,
                  icon: Icons.settings,
                  title: 'Configuración',
                  subtitle: 'Ajustes de la app',
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('⚙️ Configuración del Mundial 2024'),
                        backgroundColor: Colors.blue,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          
          // Footer del drawer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(
                top: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.grey),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Desarrollado con Flutter\nSantiago Martinez Serna',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    String? route,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFE60000).withOpacity(0.1),
                const Color(0xFF007AFF).withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFE60000),
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13,
          ),
        ),
        onTap: onTap ??
            () {
              Navigator.pop(context);
              if (route != null) {
                // Agregar logs para debug
                print('🚀 DRAWER NAVIGATION: $title -> $route');
                if (route == '/') {
                  context.go(route);
                } else {
                  context.push(route);
                }
              }
            },
        trailing: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
