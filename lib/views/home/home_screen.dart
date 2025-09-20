import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/cyclist_card.dart';
import '../../widgets/stage_button.dart';
import '../../widgets/custom_navbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String appBarTitle = "Mundial 2024";
  final String studentName = "Santiago Martinez Serna";
  int _currentTabIndex = 0;

  // Funciones de navegación con logs de parámetros
  void _navigateWithGo() {
    final url = '/details?name=${Uri.encodeComponent(studentName)}&from=go';
    if (kDebugMode) {
      print("🚀=== NAVEGACIÓN CON GO ===");
      print("📦 Parámetros siendo pasados:");
      print("   • name: '$studentName'");
      print("   • from: 'go'");
      print("🌐 URL completa: '$url'");
      print("⚡ Método: context.go() - Reemplaza toda la pila de navegación");
      print("================================");
    }
    context.go(url);
  }

  void _navigateWithPush() {
    final url = '/details?name=${Uri.encodeComponent(studentName)}&from=push';
    if (kDebugMode) {
      print("🚀=== NAVEGACIÓN CON PUSH ===");
      print("📦 Parámetros siendo pasados:");
      print("   • name: '$studentName'");
      print("   • from: 'push'");
      print("🌐 URL completa: '$url'");
      print("⚡ Método: context.push() - Agrega a la pila de navegación");
      print("================================");
    }
    context.push(url);
  }

  void _navigateWithReplace() {
    final url = '/details?name=${Uri.encodeComponent(studentName)}&from=replace';
    if (kDebugMode) {
      print("🚀=== NAVEGACIÓN CON REPLACE ===");
      print("📦 Parámetros siendo pasados:");
      print("   • name: '$studentName'");
      print("   • from: 'replace'");
      print("🌐 URL completa: '$url'");
      print("⚡ Método: context.pushReplacement() - Reemplaza pantalla actual");
      print("================================");
    }
    context.pushReplacement(url);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.pedal_bike), text: 'Carrera'),
              Tab(icon: Icon(Icons.leaderboard), text: 'Clasificación'),
              Tab(icon: Icon(Icons.info), text: 'Información'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildRaceTab(),
            _buildClassificationTab(),
            _buildInfoTab(),
          ],
        ),
        bottomNavigationBar: CustomNavBar(
          currentIndex: _currentTabIndex,
          onTap: (index) => setState(() => _currentTabIndex = index),
          studentName: studentName,
        ),
      ),
    );
  }

  Widget _buildRaceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Tarjeta con nombre
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE60000), Color(0xFF007AFF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    studentName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Icon(Icons.pedal_bike, color: Colors.white, size: 30),
              ],
            ),
          ),

          // Ciclistas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              CyclistCard(
                imageUrl:
                    "https://upload.wikimedia.org/wikipedia/commons/thumb/4/48/Jonas_Vingegaard_-_2022.jpg/250px-Jonas_Vingegaard_-_2022.jpg",
                label: "Candidato 1",
              ),
              CyclistCard(
                imageUrl:
                    "https://s1.sportstatics.com/relevo/www/multimedia/202411/23/media/cortadas/tadej-pogacar-afp-Rb6dqhzuwn1GkzJI60aezGO-1200x648@Relevo.jpg",
                label: "Candidato 2",
              ),
            ],
          ),

          const SizedBox(height: 30),
          const Text('Selecciona una etapa:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              StageButton(
                text: "Navegar con GO",
                icon: Icons.flag,
                color: Color(0xFFE60000),
                onPressed: _navigateWithGo,
              ),
              StageButton(
                text: "Navegar con PUSH",
                icon: Icons.navigation,
                color: Colors.green,
                onPressed: _navigateWithPush,
              ),
              StageButton(
                text: "Navegar con REPLACE",
                icon: Icons.swap_horiz,
                color: Colors.purple,
                onPressed: _navigateWithReplace,
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildClassificationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Título de la sección
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.leaderboard, color: Colors.white, size: 30),
                SizedBox(width: 10),
                Text(
                  'Clasificación General',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Lista de clasificación
          _buildClassificationItem(1, "Tadej Pogačar", "UAE Team Emirates", "85:23:45"),
          _buildClassificationItem(2, "Jonas Vingegaard", "Jumbo-Visma", "85:24:12"),
          _buildClassificationItem(3, "Geraint Thomas", "INEOS Grenadiers", "85:25:33"),
          _buildClassificationItem(4, "Egan Bernal", "INEOS Grenadiers", "85:26:01"),
          _buildClassificationItem(5, "Primož Roglič", "Jumbo-Visma", "85:27:18"),
        ],
      ),
    );
  }

  Widget _buildClassificationItem(int position, String name, String team, String time) {
    Color positionColor;
    switch (position) {
      case 1:
        positionColor = Colors.amber;
        break;
      case 2:
        positionColor = Colors.grey[400]!;
        break;
      case 3:
        positionColor = Colors.brown[300]!;
        break;
      default:
        positionColor = Colors.blue[100]!;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: positionColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$position',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  team,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Título de la sección
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF007AFF), Color(0xFF5856D6)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info, color: Colors.white, size: 30),
                SizedBox(width: 10),
                Text(
                  'Información del Mundial',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Información general
          _buildInfoCard(
            'Información del Evento',
            [
              _buildInfoRow('Evento:', 'Mundial de Ciclismo de Ruta 2024'),
              _buildInfoRow('Fecha:', '22-29 de Septiembre 2024'),
              _buildInfoRow('Lugar:', 'Zurich, Suiza'),
              _buildInfoRow('Distancia total:', '273.9 km'),
            ],
          ),

          const SizedBox(height: 16),

          _buildInfoCard(
            'Información del Desarrollador',
            [
              _buildInfoRow('Estudiante:', studentName),
              _buildInfoRow('Materia:', 'Desarrollo Móvil'),
              _buildInfoRow('Proyecto:', 'Taller Paso de Parámetros'),
              _buildInfoRow('Tecnología:', 'Flutter & Dart'),
            ],
          ),

          const SizedBox(height: 16),

          _buildInfoCard(
            'Funcionalidades',
            [
              _buildInfoRow('Navegación:', 'Go Router'),
              _buildInfoRow('Paso de parámetros:', 'Query Parameters'),
              _buildInfoRow('Diseño:', 'Material Design'),
              _buildInfoRow('Responsive:', 'Adaptive UI'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
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
      ),
    );
  }
}
