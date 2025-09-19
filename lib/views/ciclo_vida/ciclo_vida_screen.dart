import 'package:flutter/material.dart';

class CicloVidaScreen extends StatelessWidget {
  const CicloVidaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ciclo de Vida')),
      body: const Center(child: Text('Las pantallas registran initState/didChangeDependencies/build/setState/dispose en consola.')),
    );
  }
}
