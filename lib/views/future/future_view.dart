import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import '../../widgets/base_view.dart';

class FutureView extends StatefulWidget {
  const FutureView({super.key});

  @override
  State<FutureView> createState() => _FutureViewState();
}

class _FutureViewState extends State<FutureView> {
  List<Map<String, String>> _ciclistas = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    print('🚴‍♂️ INIT: Iniciando aplicación de ciclismo');
    obtenerDatosCiclistas();
  }

  // ✅ SERVICIO SIMULADO CON FUTURE.DELAYED (2-3 SEGUNDOS)
  Future<List<Map<String, String>>> cargarCiclistasDelServidor() async {
    print('🌐 DURANTE: Iniciando consulta asíncrona al servidor de ciclistas...');
    
    // ✅ FUTURE.DELAYED DE 2-3 SEGUNDOS COMO REQUERIDO
    final delaySegundos = 2 + Random().nextInt(2); // Genera 2 o 3 segundos
    print('⏱️ DURANTE: Simulando delay de red de $delaySegundos segundos...');
    await Future.delayed(Duration(seconds: delaySegundos));
    
    // ✅ SIMULACIÓN DE ERROR PARA MOSTRAR ESTADO DE ERROR
    if (Random().nextInt(10) == 0) {
      print('❌ DURANTE: Simulando fallo en la conexión al servidor');
      throw Exception('Error de conexión al servidor de ciclismo mundial');
    }
    
    print('✅ DURANTE: Datos de ciclistas mundiales recibidos exitosamente');
    
    // ✅ DATOS DE CICLISTAS ACTUALES COMO POGAČAR, VINGEGAARD, ETC.
    return [
      {'nombre': 'Tadej Pogačar', 'equipo': 'UAE Team Emirates', 'pais': '🇸🇮'},
      {'nombre': 'Jonas Vingegaard', 'equipo': 'Visma-Lease a Bike', 'pais': '🇩🇰'},
      {'nombre': 'Remco Evenepoel', 'equipo': 'Soudal Quick-Step', 'pais': '🇧🇪'},
      {'nombre': 'Tom Pidcock', 'equipo': 'INEOS Grenadiers', 'pais': '🇬🇧'},
      {'nombre': 'Egan Bernal', 'equipo': 'INEOS Grenadiers', 'pais': '🇨🇴'},
      {'nombre': 'Primož Roglič', 'equipo': 'Red Bull-BORA-hansgrohe', 'pais': '🇸🇮'},
      {'nombre': 'Mathieu van der Poel', 'equipo': 'Alpecin-Deceuninck', 'pais': '🇳🇱'},
      {'nombre': 'Wout van Aert', 'equipo': 'Visma-Lease a Bike', 'pais': '🇧🇪'},
      {'nombre': 'Geraint Thomas', 'equipo': 'INEOS Grenadiers', 'pais': '🇬🇧'},
      {'nombre': 'Enric Mas', 'equipo': 'Movistar Team', 'pais': '🇪🇸'},
      {'nombre': 'Nairo Quintana', 'equipo': 'Movistar Team', 'pais': '🇨🇴'},
      {'nombre': 'Rigoberto Urán', 'equipo': 'EF Education-EasyPost', 'pais': '🇨🇴'},
    ];
  }

  // ✅ FUNCIÓN QUE OBTIENE LOS DATOS USANDO ASYNC/AWAIT
  Future<void> obtenerDatosCiclistas() async {
    print('📡 ANTES: Preparando consulta de ciclistas...');
    
    setState(() {
      _isLoading = true;
      _error = null;
      _ciclistas = [];
    });

    try {
      print('⏳ DURANTE: Consultando base de datos de ciclistas...');
      
      // ✅ USO DE ASYNC/AWAIT PARA ESPERAR EL RESULTADO SIN BLOQUEAR UI
      final datos = await cargarCiclistasDelServidor();
      
      if (!mounted) {
        print('⚠️ WARNING: Widget desmontado, cancelando actualización');
        return;
      }
      
      setState(() {
        _ciclistas = datos;
        _isLoading = false;
      });
      
      print('🏁 DESPUÉS: Ciclistas cargados exitosamente (${datos.length} ciclistas)');
      
    } catch (e) {
      print('💥 ERROR CAUGHT: ${e.toString()}');
      
      if (!mounted) return;
      
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      
      print('🔴 DESPUÉS: Error manejado y UI actualizada');
    }
  }

  // Función para recargar datos
  void recargarDatos() {
    print('🔄 RELOAD: Usuario solicitó recarga de datos');
    obtenerDatosCiclistas();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Ciclismo Mundial - Futures',
      showBackButton: true,
      showDrawer: false, // No mostrar drawer en vistas secundarias
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Botón de recarga
            ElevatedButton.icon(
              onPressed: _isLoading ? null : recargarDatos,
              icon: Icon(_isLoading ? Icons.hourglass_empty : Icons.refresh),
              label: Text(_isLoading ? 'Cargando...' : 'Recargar Ciclistas'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 193, 7),
                foregroundColor: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            
            // Contenido principal
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    // Estado de carga
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color.fromARGB(255, 255, 193, 7),
              strokeWidth: 3,
            ),
            SizedBox(height: 20),
            Text(
              '🚴‍♂️ Cargando ciclistas...',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),
            Text(
              'Consultando base de datos mundial',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // Estado de error
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            const Text(
              '❌ Error al cargar',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: recargarDatos,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    // Estado de éxito - GridView con ciclistas
    return GridView.builder(
      itemCount: _ciclistas.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final ciclista = _ciclistas[index];
        return Card(
          elevation: 3,
          color: const Color.fromARGB(255, 255, 193, 7),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ciclista['pais']!,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 5),
                Text(
                  ciclista['nombre']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  ciclista['equipo']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 68, 68, 68),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    print('🗑️ DISPOSE: Limpiando recursos de la vista de ciclismo');
    super.dispose();
  }
}