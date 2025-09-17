import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String appBarTitle = "Tour de Flutter";
  final String studentName = "Santiago Martinez Serna";
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    print('🟢 HomeScreen: initState() - Widget creado e inicializado');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('🔵 HomeScreen: didChangeDependencies() - Dependencias disponibles');
  }

  @override
  Widget build(BuildContext context) {
    print('🟡 HomeScreen: build() - Widget siendo construido/reconstruido');
    
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          backgroundColor: const Color(0xFFE60000),
          foregroundColor: Colors.white,
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
        bottomNavigationBar: _buildCyclingThemedNavBar(),
      ),
    );
  }

  Widget _buildRaceTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Nombre del estudiante con estilo ciclista
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
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
            
            const SizedBox(height: 20),
            
            // Row con imágenes de ciclismo
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCyclistCard(
                  "https://olimpicocol.co/web/wp-content/uploads/2024/09/Seleccion-Colombia-Mundial-de-ciclsimo-de-Ruta-Zurich-2024.png",
                  "Selección Colombia Mundial 2024"
                ),
                
                _buildCyclistCard(
                  "https://cdn.pixabay.com/photo/2013/07/12/18/39/mountain-bike-153632_1280.png",
                  "Bicicleta de montaña"
                ),
              ],
            ),
            
            const SizedBox(height: 30),
            
            // Sección de etapas (botones de navegación)
            const Text(
              'Selecciona una etapa:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            
            const SizedBox(height: 16),
            
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildStageButton(
                  "Navegar con GO",
                  Icons.flag,
                  const Color(0xFFE60000),
                  () => context.go('/details?name=${Uri.encodeComponent(studentName)}&from=go'),
                ),
                _buildStageButton(
                  "Navegar con PUSH",
                  Icons.navigation,
                  Colors.green,
                  () => context.push('/details?name=${Uri.encodeComponent(studentName)}&from=push'),
                ),
                _buildStageButton(
                  "Navegar con REPLACE",
                  Icons.swap_horiz,
                  Colors.purple,
                  () => context.pushReplacement('/details?name=${Uri.encodeComponent(studentName)}&from=replace'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCyclistCard(String imageUrl, String label) {
    return Column(
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE60000), width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, size: 40, color: Colors.red),
                      Text("Imagen no disponible"),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStageButton(String text, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildClassificationTab() {
    final List<Map<String, dynamic>> cyclists = [
      {'name': 'Tadej Pogačar', 'country': 'Eslovenia', 'points': 520, 'color': Colors.blue},
      {'name': 'Jonas Vingegaard', 'country': 'Dinamarca', 'points': 490, 'color': Colors.red},
      {'name': 'Remco Evenepoel', 'country': 'Bélgica', 'points': 450, 'color': Colors.black},
      {'name': 'Primož Roglič', 'country': 'Eslovenia', 'points': 430, 'color': Colors.white},
      {'name': 'Mathieu van der Poel', 'country': 'Países Bajos', 'points': 410, 'color': Colors.orange},
      {'name': 'Wout van Aert', 'country': 'Bélgica', 'points': 390, 'color': Colors.yellow},
      {'name': 'Egan Bernal', 'country': 'Colombia', 'points': 370, 'color': Colors.blue[900]!},
      {'name': 'Julian Alaphilippe', 'country': 'Francia', 'points': 350, 'color': Colors.blue[700]!},
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: cyclists.length,
        itemBuilder: (context, index) {
          final cyclist = cyclists[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: cyclist['color'] as Color,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                cyclist['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(cyclist['country']),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE60000),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${cyclist['points']} pts',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Información del Mundial de Ciclismo',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
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
                  const Text('Características implementadas:', 
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  _buildInfoItem('• TabBar con 3 secciones temáticas'),
                  _buildInfoItem('• Clasificación de ciclistas con ListView'),
                  _buildInfoItem('• Navegación con go_router'),
                  _buildInfoItem('• Paso de parámetros entre pantallas'),
                  _buildInfoItem('• Widgets personalizados con temática ciclista'),
                  const SizedBox(height: 16),
                  const Text('Tecnologías utilizadas:', 
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  _buildInfoItem('• GoRouter para navegación'),
                  _buildInfoItem('• Material Design 3'),
                  _buildInfoItem('• Widgets de ciclo de vida'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(text),
    );
  }

  Widget _buildCyclingThemedNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentTabIndex,
      onTap: (index) {
        setState(() {
          _currentTabIndex = index;
        });
        
        if (index == 1) {
          // Navegación a pantalla de detalles
          context.go('/details?name=${Uri.encodeComponent(studentName)}&from=home');
        } else if (index == 2) {
          // Mostrar SnackBar con información rápida
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Configuración del Tour de Flutter"),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      },
      selectedItemColor: const Color(0xFFE60000),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.navigate_next),
          label: 'Navegar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Config',
        ),
      ],
    );
  }

  @override
  void dispose() {
    print('🔴 HomeScreen: dispose() - Widget siendo eliminado, limpiando recursos');
    super.dispose();
  }
}