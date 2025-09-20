import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../widgets/base_view.dart';

class CicloVidaScreen extends StatefulWidget {
  const CicloVidaScreen({super.key});

  @override
  State<CicloVidaScreen> createState() => CicloVidaScreenState();
}

class CicloVidaScreenState extends State<CicloVidaScreen> {
  String texto = "Texto inicial 🟢";
  List<String> logs = [];

  void _addLog(String log) {
    setState(() {
      logs.add("${DateTime.now().toString().substring(11, 19)} - $log");
      if (logs.length > 10) {
        logs.removeAt(0); // Mantener solo los últimos 10 logs
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
    _addLog("🟢 CicloVidaScreen: initState() - Estado inicial del widget");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _addLog("🔵 CicloVidaScreen: didChangeDependencies() - Dependencias han cambiado");
  }

  @override
  Widget build(BuildContext context) {
    _addLog("🟡 CicloVidaScreen: build() - Construyendo interfaz de usuario");

    return BaseView(
      title: "Ciclo de Vida en Flutter",
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Estado actual
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.green, Colors.teal],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    texto,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: actualizarTexto,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.green,
                    ),
                    child: const Text("Actualizar Texto (setState)"),
                  ),
                ],
              ),
            ),

            // Logs del ciclo de vida
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "📋 Logs del Ciclo de Vida:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: logs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(
                              logs[index],
                              style: const TextStyle(
                                fontSize: 12,
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
          ],
        ),
      ),
    );
  }

  void actualizarTexto() {
    setState(() {
      texto = "Texto actualizado 🟠";
    });
    _addLog("🟠 CicloVidaScreen: setState() - Estado del widget ha cambiado");
  }

  @override
  void dispose() {
    _addLog("🔴 CicloVidaScreen: dispose() - Liberando recursos del widget");
    super.dispose();
  }
}
