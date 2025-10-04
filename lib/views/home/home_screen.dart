import 'package:flutter/material.dart';
import '../../widgets/cyclist_card.dart';
import '../../widgets/custom_navbar.dart';
import '../../widgets/cycling_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String appBarTitle = "Mundial 2024";
  final String studentName = "Santiago Martinez Serna";
  int _currentTabIndex = 0;

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
        drawer: const CyclingDrawer(),
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
          
          // Mensaje sobre la pasión por el ciclismo
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFFD700), // Dorado
                  Color(0xFFFFA500), // Naranja
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 28,
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.pedal_bike,
                      color: Colors.white,
                      size: 32,
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.public,
                      color: Colors.blue,
                      size: 28,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  '🚴‍♂️ Pasión por el Ciclismo Mundial',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Este desarrollo está inspirado en la gran pasión y gusto que tiene el desarrollador Santiago Martínez por el ciclismo de ruta. Un deporte que une países, culturas y personas bajo la misma emoción: la velocidad, la resistencia y la superación personal.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Explora las funciones desde el menú lateral',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
              _buildInfoRow('Proyecto:', 'Taller de Segundo Plano'),
              _buildInfoRow('Tecnología:', 'Flutter & Dart'),
              _buildInfoRow('Inspiración:', 'Pasión por el ciclismo mundial'),
              _buildInfoRow('Temática:', 'Une países y culturas'),
            ],
          ),

          const SizedBox(height: 16),

          _buildInfoCard(
            'Funcionalidades Implementadas',
            [
              _buildInfoRow('Navegación:', 'Menú lateral desplegable'),
              _buildInfoRow('Future/Async:', 'Ciclistas mundiales'),
              _buildInfoRow('Timer:', 'Cronómetro de entrenamiento'),
              _buildInfoRow('Isolate:', 'Análisis de rendimiento'),
              _buildInfoRow('Ciclo de vida:', 'Estados de widgets'),
              _buildInfoRow('Asincronia:', 'Future.delayed y await'),
              _buildInfoRow('Precisión:', 'Timer cada 100ms'),
              _buildInfoRow('CPU-Bound:', 'Cálculos en Isolate'),
              _buildInfoRow('Diseño:', 'Material Design temático'),
              _buildInfoRow('Responsive:', 'Adaptive UI ciclista'),
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
