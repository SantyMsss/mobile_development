import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../widgets/base_view.dart';

// ✅ MODELO DE DATOS PARA ANÁLISIS CICLISTA
class CyclingAnalysis {
  final String cyclistName;
  final double averageSpeed;
  final double maxSpeed;
  final double totalDistance;
  final double totalTime;
  final double caloriesBurned;
  final double powerOutput;
  final int heartRateAvg;
  final int heartRateMax;
  final List<double> elevationProfile;

  CyclingAnalysis({
    required this.cyclistName,
    required this.averageSpeed,
    required this.maxSpeed,
    required this.totalDistance,
    required this.totalTime,
    required this.caloriesBurned,
    required this.powerOutput,
    required this.heartRateAvg,
    required this.heartRateMax,
    required this.elevationProfile,
  });

  Map<String, dynamic> toMap() {
    return {
      'cyclistName': cyclistName,
      'averageSpeed': averageSpeed,
      'maxSpeed': maxSpeed,
      'totalDistance': totalDistance,
      'totalTime': totalTime,
      'caloriesBurned': caloriesBurned,
      'powerOutput': powerOutput,
      'heartRateAvg': heartRateAvg,
      'heartRateMax': heartRateMax,
      'elevationProfile': elevationProfile,
    };
  }

  factory CyclingAnalysis.fromMap(Map<String, dynamic> map) {
    return CyclingAnalysis(
      cyclistName: map['cyclistName'],
      averageSpeed: map['averageSpeed'],
      maxSpeed: map['maxSpeed'],
      totalDistance: map['totalDistance'],
      totalTime: map['totalTime'],
      caloriesBurned: map['caloriesBurned'],
      powerOutput: map['powerOutput'],
      heartRateAvg: map['heartRateAvg'],
      heartRateMax: map['heartRateMax'],
      elevationProfile: List<double>.from(map['elevationProfile']),
    );
  }
}

// ✅ FUNCIÓN CPU-BOUND PARA COMPUTE() (WEB FALLBACK)
Map<String, dynamic> performCyclingAnalysisSync(int seed) {
  print('🔬 COMPUTE WORKER: Iniciando análisis pesado de datos ciclistas');

  final Random random = Random(seed);
  final List<double> speedData = [];
  final List<double> elevationData = [];
  final List<int> heartRateData = [];
  final List<double> powerData = [];

  // ✅ SIMULACIÓN DE TAREA CPU-INTENSIVA (50,000 iteraciones)
  const int totalDataPoints = 50000;
  
  for (int i = 0; i < totalDataPoints; i++) {
    // Generar datos de velocidad (20-55 km/h)
    speedData.add(20.0 + random.nextDouble() * 35.0);
    
    // Generar perfil de elevación (0-2000m)
    elevationData.add(random.nextDouble() * 2000);
    
    // Generar datos de frecuencia cardíaca (120-190 bpm)
    heartRateData.add(120 + random.nextInt(70));
    
    // Generar datos de potencia (150-450 watts)
    powerData.add(150.0 + random.nextDouble() * 300.0);

    // ✅ CÁLCULOS CPU-INTENSIVOS
    double complexCalculation = 0;
    for (int j = 0; j < 50; j++) {
      complexCalculation += sqrt(i * j + 1) * sin(i * 0.01) * cos(j * 0.01);
    }
    // Usar el resultado para evitar optimización del compilador
    if (complexCalculation > 500000) {
      if (kDebugMode && i % 10000 == 0) print('Cálculo complejo: $complexCalculation');
    }
  }

  // ✅ CÁLCULOS ESTADÍSTICOS PESADOS
  final avgSpeed = speedData.reduce((a, b) => a + b) / speedData.length;
  final maxSpeed = speedData.reduce((a, b) => a > b ? a : b);
  final avgHeartRate = heartRateData.reduce((a, b) => a + b) ~/ heartRateData.length;
  final maxHeartRate = heartRateData.reduce((a, b) => a > b ? a : b);
  final avgPower = powerData.reduce((a, b) => a + b) / powerData.length;
  
  // Simular tiempo de entrenamiento (2-4 horas)
  final totalTime = 2.0 + random.nextDouble() * 2.0;
  final totalDistance = avgSpeed * totalTime;
  final caloriesBurned = totalTime * avgPower * 3.6;

  // Seleccionar 20 puntos del perfil de elevación
  final elevationProfile = <double>[];
  for (int i = 0; i < 20; i++) {
    final index = (i * elevationData.length / 20).floor();
    elevationProfile.add(elevationData[index]);
  }

  // Lista de ciclistas profesionales
  final cyclists = [
    'Tadej Pogačar', 'Jonas Vingegaard', 'Remco Evenepoel', 'Tom Pidcock',
    'Egan Bernal', 'Primož Roglič', 'Mathieu van der Poel', 'Wout van Aert'
  ];

  // ✅ CREAR RESULTADO DEL ANÁLISIS
  final analysis = CyclingAnalysis(
    cyclistName: cyclists[random.nextInt(cyclists.length)],
    averageSpeed: double.parse(avgSpeed.toStringAsFixed(1)),
    maxSpeed: double.parse(maxSpeed.toStringAsFixed(1)),
    totalDistance: double.parse(totalDistance.toStringAsFixed(1)),
    totalTime: double.parse(totalTime.toStringAsFixed(2)),
    caloriesBurned: double.parse(caloriesBurned.toStringAsFixed(0)),
    powerOutput: double.parse(avgPower.toStringAsFixed(0)),
    heartRateAvg: avgHeartRate,
    heartRateMax: maxHeartRate,
    elevationProfile: elevationProfile,
  );

  print('🏁 COMPUTE WORKER: Análisis completado');
  return analysis.toMap();
}

class IsolateView extends StatefulWidget {
  const IsolateView({super.key});

  @override
  State<IsolateView> createState() => _IsolateViewState();
}

class _IsolateViewState extends State<IsolateView> {
  CyclingAnalysis? _analysisResult;
  bool _isAnalyzing = false;
  String _status = "Presiona el botón para analizar rendimiento ciclista";
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    print('🚴‍♂️ ISOLATE INIT: Vista de análisis ciclista inicializada');
  }

  // ✅ FUNCIÓN QUE EJECUTA ANÁLISIS PESADO CON ISOLATE.SPAWN
  Future<void> _startCyclingAnalysis() async {
    print('🚀 ISOLATE START: Iniciando análisis de rendimiento ciclista');
    
    setState(() {
      _isAnalyzing = true;
      _status = "Analizando datos de rendimiento...";
      _progress = 0.0;
      _analysisResult = null;
    });

    try {
      if (kIsWeb) {
        // ✅ FALLBACK PARA WEB CON COMPUTE()
        print('🌐 WEB MODE: Usando compute() como fallback');
        
        // Simular progreso
        Timer.periodic(const Duration(milliseconds: 300), (timer) {
          if (mounted && _isAnalyzing && _progress < 0.9) {
            setState(() {
              _progress += 0.1;
              _status = "Procesando datos... ${(_progress * 100).toInt()}%";
            });
          } else {
            timer.cancel();
          }
        });

        final resultMap = await compute(performCyclingAnalysisSync, DateTime.now().millisecondsSinceEpoch);
        
        if (mounted) {
          setState(() {
            _analysisResult = CyclingAnalysis.fromMap(resultMap);
            _isAnalyzing = false;
            _status = "Análisis completado exitosamente (Compute)";
            _progress = 1.0;
          });
        }
      } else {
        // ✅ USAR ISOLATE.SPAWN EN PLATAFORMAS NATIVAS
        print('📱 NATIVE MODE: Usando Isolate.spawn');
        
        // ✅ CREAR CANALES DE COMUNICACIÓN
        final receivePort = ReceivePort();
        final progressPort = ReceivePort();

        print('📡 ISOLATE: Creando canales de comunicación');

        // ✅ SPAWN ISOLATE CON FUNCIÓN CPU-BOUND
        await Isolate.spawn(
          _performCyclingAnalysisIsolate,
          {
            'sendPort': receivePort.sendPort,
            'progressPort': progressPort.sendPort,
            'seed': DateTime.now().millisecondsSinceEpoch,
          },
        );

        // ✅ ESCUCHAR ACTUALIZACIONES DE PROGRESO POR MENSAJES
        progressPort.listen((progress) {
          if (mounted) {
            setState(() {
              _progress = progress as double;
              _status = "Procesando datos... ${(progress * 100).toInt()}%";
            });
          }
        });

        print('⏳ ISOLATE: Esperando resultado del análisis...');

        // ✅ RECIBIR RESULTADO POR MENSAJES
        final result = await receivePort.first;
        
        if (mounted) {
          setState(() {
            _analysisResult = CyclingAnalysis.fromMap(result as Map<String, dynamic>);
            _isAnalyzing = false;
            _status = "Análisis completado exitosamente (Isolate)";
            _progress = 1.0;
          });
        }

        print('✅ ISOLATE: Análisis completado y resultado recibido');
        progressPort.close();
      }

    } catch (e) {
      print('❌ ANALYSIS ERROR: $e');
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
          _status = "Error en el análisis: $e";
        });
      }
    }
  }

  // ✅ FUNCIÓN CPU-BOUND QUE SE EJECUTA EN EL ISOLATE
  static void _performCyclingAnalysisIsolate(Map<String, dynamic> params) async {
    final SendPort sendPort = params['sendPort'];
    final SendPort progressPort = params['progressPort'];
    final int seed = params['seed'];

    print('🔬 ISOLATE WORKER: Iniciando análisis pesado de datos ciclistas');

    try {
      final Random random = Random(seed);
      final List<double> speedData = [];
      final List<double> elevationData = [];
      final List<int> heartRateData = [];
      final List<double> powerData = [];

      // ✅ SIMULACIÓN DE TAREA CPU-INTENSIVA (50,000 iteraciones)
      const int totalDataPoints = 50000;
      
      for (int i = 0; i < totalDataPoints; i++) {
        // Generar datos de velocidad (20-55 km/h)
        speedData.add(20.0 + random.nextDouble() * 35.0);
        
        // Generar perfil de elevación (0-2000m)
        elevationData.add(random.nextDouble() * 2000);
        
        // Generar datos de frecuencia cardíaca (120-190 bpm)
        heartRateData.add(120 + random.nextInt(70));
        
        // Generar datos de potencia (150-450 watts)
        powerData.add(150.0 + random.nextDouble() * 300.0);

        // ✅ REPORTAR PROGRESO CADA 2500 ITERACIONES POR MENSAJES
        if (i % 2500 == 0) {
          final progress = i / totalDataPoints;
          progressPort.send(progress);
          
          if (kDebugMode) {
            print('🔄 ISOLATE PROGRESS: ${(progress * 100).toInt()}% - Procesando punto $i');
          }
        }

        // ✅ CÁLCULOS CPU-INTENSIVOS
        double complexCalculation = 0;
        for (int j = 0; j < 50; j++) {
          complexCalculation += sqrt(i * j + 1) * sin(i * 0.01) * cos(j * 0.01);
        }
        // Usar el resultado para evitar optimización del compilador
        if (complexCalculation > 500000) {
          // Cálculo usado
        }
      }

      print('📊 ISOLATE WORKER: Calculando estadísticas finales...');

      // ✅ CÁLCULOS ESTADÍSTICOS PESADOS
      final avgSpeed = speedData.reduce((a, b) => a + b) / speedData.length;
      final maxSpeed = speedData.reduce((a, b) => a > b ? a : b);
      final avgHeartRate = heartRateData.reduce((a, b) => a + b) ~/ heartRateData.length;
      final maxHeartRate = heartRateData.reduce((a, b) => a > b ? a : b);
      final avgPower = powerData.reduce((a, b) => a + b) / powerData.length;
      
      // Simular tiempo de entrenamiento (2-4 horas)
      final totalTime = 2.0 + random.nextDouble() * 2.0;
      final totalDistance = avgSpeed * totalTime;
      final caloriesBurned = totalTime * avgPower * 3.6;

      // Seleccionar 20 puntos del perfil de elevación
      final elevationProfile = <double>[];
      for (int i = 0; i < 20; i++) {
        final index = (i * elevationData.length / 20).floor();
        elevationProfile.add(elevationData[index]);
      }

      // Lista de ciclistas profesionales
      final cyclists = [
        'Tadej Pogačar', 'Jonas Vingegaard', 'Remco Evenepoel', 'Tom Pidcock',
        'Egan Bernal', 'Primož Roglič', 'Mathieu van der Poel', 'Wout van Aert'
      ];

      // Progreso final
      progressPort.send(1.0);

      // ✅ CREAR RESULTADO DEL ANÁLISIS
      final analysis = CyclingAnalysis(
        cyclistName: cyclists[random.nextInt(cyclists.length)],
        averageSpeed: double.parse(avgSpeed.toStringAsFixed(1)),
        maxSpeed: double.parse(maxSpeed.toStringAsFixed(1)),
        totalDistance: double.parse(totalDistance.toStringAsFixed(1)),
        totalTime: double.parse(totalTime.toStringAsFixed(2)),
        caloriesBurned: double.parse(caloriesBurned.toStringAsFixed(0)),
        powerOutput: double.parse(avgPower.toStringAsFixed(0)),
        heartRateAvg: avgHeartRate,
        heartRateMax: maxHeartRate,
        elevationProfile: elevationProfile,
      );

      print('🏁 ISOLATE WORKER: Análisis completado, enviando resultado...');

      // ✅ ENVIAR RESULTADO AL HILO PRINCIPAL POR MENSAJES
      sendPort.send(analysis.toMap());
      
    } catch (e) {
      print('💥 ISOLATE WORKER ERROR: $e');
      sendPort.send({'error': e.toString()});
    }
    
    print('🗑️ ISOLATE WORKER: Finalizando Isolate');
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: "Análisis Ciclista - Isolate",
      showBackButton: true,
      showDrawer: false,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE3F2FD),
              Color(0xFFBBDEFB),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Header
              _buildHeader(),
              
              const SizedBox(height: 20),
              
              // Status y progreso
              _buildStatusSection(),
              
              const SizedBox(height: 20),
              
              // Botón de análisis
              _buildAnalysisButton(),
              
              const SizedBox(height: 20),
              
              // Resultados
              Expanded(
                child: _buildResultsSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE60000), Color(0xFF007AFF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
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
      child: const Row(
        children: [
          Icon(Icons.analytics, color: Colors.white, size: 30),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🚴‍♂️ Análisis de Rendimiento',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Procesamiento en Isolate',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            _status,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          if (_isAnalyzing) ...[
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: _progress,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFE60000)),
            ),
            const SizedBox(height: 8),
            Text(
              '${(_progress * 100).toInt()}% completado',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAnalysisButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isAnalyzing 
            ? [Colors.grey, Colors.grey[300]!]
            : [const Color(0xFFE60000), const Color(0xFFFF4444)],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: _isAnalyzing ? null : _startCyclingAnalysis,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isAnalyzing) ...[
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                ] else ...[
                  const Icon(Icons.analytics, color: Colors.white, size: 24),
                  const SizedBox(width: 8),
                ],
                Text(
                  _isAnalyzing ? 'Analizando...' : 'Iniciar Análisis Pesado',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultsSection() {
    if (_analysisResult == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.analytics_outlined,
                size: 80,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'No hay resultados aún',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Ejecuta el análisis para ver los datos de rendimiento',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título del ciclista
            Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.emoji_events,
                    color: Color(0xFFFFD700),
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _analysisResult!.cyclistName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE60000),
                    ),
                  ),
                  const Text(
                    'Análisis de Rendimiento',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Estadísticas en grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _buildStatCard(
                  '🚀 Vel. Promedio',
                  '${_analysisResult!.averageSpeed} km/h',
                  Colors.blue,
                ),
                _buildStatCard(
                  '⚡ Vel. Máxima',
                  '${_analysisResult!.maxSpeed} km/h',
                  Colors.orange,
                ),
                _buildStatCard(
                  '📏 Distancia',
                  '${_analysisResult!.totalDistance} km',
                  Colors.green,
                ),
                _buildStatCard(
                  '⏱️ Tiempo',
                  '${_analysisResult!.totalTime} h',
                  Colors.purple,
                ),
                _buildStatCard(
                  '🔥 Calorías',
                  '${_analysisResult!.caloriesBurned.toInt()}',
                  Colors.red,
                ),
                _buildStatCard(
                  '⚡ Potencia',
                  '${_analysisResult!.powerOutput.toInt()} W',
                  Colors.amber,
                ),
                _buildStatCard(
                  '❤️ FC Prom.',
                  '${_analysisResult!.heartRateAvg} bpm',
                  Colors.pink,
                ),
                _buildStatCard(
                  '💓 FC Máx.',
                  '${_analysisResult!.heartRateMax} bpm',
                  Colors.deepOrange,
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Información técnica del Isolate
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🔬 Información Técnica',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE60000),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('• Nativo: Isolate.spawn con mensajes'),
                  Text('• Web: compute() como fallback'),
                  Text('• 50,000 puntos de datos analizados'),
                  Text('• Cálculos CPU-intensivos realizados'),
                  Text('• Progreso en tiempo real por mensajes'),
                  Text('• UI no bloqueada durante el proceso'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    print('🗑️ ISOLATE DISPOSE: Limpiando recursos de análisis ciclista');
    super.dispose();
  }
}
