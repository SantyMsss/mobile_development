import 'dart:async';
import 'package:flutter/material.dart';
import '../../widgets/base_view.dart';

class TimerView extends StatefulWidget {
  const TimerView({super.key});

  @override
  State<TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  // ✅ TIMER PARA ACTUALIZACIÓN CADA 100MS
  Timer? _timer;
  
  // Estados del cronómetro
  Duration _elapsed = Duration.zero;
  bool _isRunning = false;
  bool _isPaused = false;
  
  // Para tracking de tiempo
  DateTime? _startTime;
  Duration _pausedDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    print('🏁 TIMER INIT: Cronómetro ciclista inicializado');
  }

  // ✅ FUNCIONES DEL CRONÓMETRO

  void _startTimer() {
    if (_timer != null && _timer!.isActive) return;
    
    print('▶️ TIMER START: Iniciando cronómetro');
    _startTime = DateTime.now().subtract(_pausedDuration);
    _isRunning = true;
    _isPaused = false;
    
    // ✅ TIMER CON ACTUALIZACIÓN CADA 100MS
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted) {
        setState(() {
          _elapsed = DateTime.now().difference(_startTime!);
        });
      }
    });
  }

  void _pauseTimer() {
    if (_timer != null) {
      print('⏸️ TIMER PAUSE: Pausando cronómetro');
      _timer!.cancel();
      _pausedDuration = _elapsed;
      _isRunning = false;
      _isPaused = true;
    }
  }

  void _resumeTimer() {
    if (_isPaused) {
      print('▶️ TIMER RESUME: Reanudando cronómetro');
      _startTimer();
    }
  }

  void _resetTimer() {
    print('🔄 TIMER RESET: Reiniciando cronómetro');
    // ✅ LIMPIEZA DE RECURSOS AL REINICIAR
    _timer?.cancel();
    setState(() {
      _elapsed = Duration.zero;
      _pausedDuration = Duration.zero;
      _isRunning = false;
      _isPaused = false;
      _startTime = null;
    });
  }

  // ✅ FORMATEAR TIEMPO PARA MOSTRAR
  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitsMs(int n) => (n ~/ 10).toString().padLeft(2, '0');
    
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final milliseconds = twoDigitsMs(duration.inMilliseconds.remainder(1000));
    
    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds.$milliseconds';
    } else {
      return '$minutes:$seconds.$milliseconds';
    }
  }

  // ✅ OBTENER COLOR SEGÚN ESTADO
  Color _getTimerColor() {
    if (_isRunning) return Colors.green;
    if (_isPaused) return Colors.orange;
    return const Color(0xFFE60000);
  }

  // ✅ OBTENER ÍCONO SEGÚN ESTADO
  IconData _getTimerIcon() {
    if (_isRunning) return Icons.pause;
    if (_isPaused) return Icons.play_arrow;
    return Icons.play_arrow;
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Cronómetro Ciclista',
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
              // Header informativo
              _buildHeader(),
              
              const SizedBox(height: 40),
              
              // ✅ MARCADOR PRINCIPAL DEL TIEMPO
              _buildTimeDisplay(),
              
              const SizedBox(height: 40),
              
              // Estado del cronómetro
              _buildStatusIndicator(),
              
              const SizedBox(height: 40),
              
              // ✅ BOTONES DE CONTROL
              _buildControlButtons(),
              
              const SizedBox(height: 40),
              
              // Información adicional
              _buildInfoSection(),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.timer, color: Colors.white, size: 30),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              '🚴‍♂️ Cronómetro de Entrenamiento',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeDisplay() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _getTimerColor().withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 15,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // ✅ TEXTO GRANDE ESTILO MARCADOR
          Text(
            _formatTime(_elapsed),
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: _getTimerColor(),
              fontFamily: 'monospace',
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _elapsed.inHours > 0 ? 'HH:MM:SS.CS' : 'MM:SS.CS',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
              letterSpacing: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator() {
    String status;
    Color statusColor;
    IconData statusIcon;

    if (_isRunning) {
      status = 'CORRIENDO';
      statusColor = Colors.green;
      statusIcon = Icons.directions_run;
    } else if (_isPaused) {
      status = 'PAUSADO';
      statusColor = Colors.orange;
      statusIcon = Icons.pause_circle;
    } else {
      status = 'DETENIDO';
      statusColor = const Color(0xFFE60000);
      statusIcon = Icons.stop_circle;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: statusColor, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, color: statusColor, size: 24),
          const SizedBox(width: 8),
          Text(
            status,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: statusColor,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButtons() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ✅ BOTÓN PRINCIPAL (INICIAR/PAUSAR/REANUDAR)
            _buildControlButton(
              onPressed: () {
                if (!_isRunning && !_isPaused) {
                  _startTimer();
                } else if (_isRunning) {
                  _pauseTimer();
                } else if (_isPaused) {
                  _resumeTimer();
                }
              },
              icon: _getTimerIcon(),
              label: _isRunning ? 'PAUSAR' : (_isPaused ? 'REANUDAR' : 'INICIAR'),
              color: _isRunning ? Colors.orange : Colors.green,
              size: 70,
            ),
          ],
        ),
        
        const SizedBox(height: 20),
        
        // ✅ BOTÓN REINICIAR
        _buildControlButton(
          onPressed: _resetTimer,
          icon: Icons.refresh,
          label: 'REINICIAR',
          color: const Color(0xFFE60000),
          size: 50,
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
    required double size,
  }) {
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(size / 2),
              onTap: onPressed,
              child: Icon(
                icon,
                color: Colors.white,
                size: size * 0.4,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📊 Información del Cronómetro',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE60000),
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('⏱️ Precisión:', '100 milisegundos'),
            _buildInfoRow('🔄 Actualización:', 'Cada 100ms'),
            _buildInfoRow('💾 Estado:', _isRunning ? 'Activo' : (_isPaused ? 'Pausado' : 'Inactivo')),
            _buildInfoRow('🧹 Limpieza:', 'Automática al salir'),
            const SizedBox(height: 12),
            const Text(
              '🚴‍♂️ Ideal para cronometrar entrenamientos de ciclismo, intervalos de velocidad y recuperación.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    print('🗑️ TIMER DISPOSE: Limpiando recursos del cronómetro');
    // ✅ LIMPIEZA DE RECURSOS AL SALIR DE LA VISTA
    _timer?.cancel();
    super.dispose();
  }
}