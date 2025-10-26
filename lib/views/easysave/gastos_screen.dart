import 'package:flutter/material.dart';
import '../../models/easysave_models.dart';
import '../../services/easysave_service.dart';
import '../../services/storage_service.dart';

class GastosScreen extends StatefulWidget {
  const GastosScreen({super.key});

  @override
  State<GastosScreen> createState() => _GastosScreenState();
}

class _GastosScreenState extends State<GastosScreen> {
  final EasySaveService _easySaveService = EasySaveService();
  final StorageService _storage = StorageService();
  
  List<Gasto> _gastos = [];
  bool _isLoading = true;
  String? _errorMessage;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadGastos();
  }

  Future<void> _loadGastos() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userId = await _storage.getUserId();
      if (userId == null) {
        throw Exception('No se encontró el ID de usuario');
      }

      setState(() {
        _userId = userId;
      });

      final gastos = await _easySaveService.getGastos(userId);
      
      setState(() {
        _gastos = gastos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _showAddGastoDialog() async {
    final formKey = GlobalKey<FormState>();
    final nombreController = TextEditingController();
    final valorController = TextEditingController();
    String estadoGasto = 'fijo';

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nuevo Gasto'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del gasto',
                  prefixIcon: Icon(Icons.label),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: valorController,
                decoration: const InputDecoration(
                  labelText: 'Valor',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un valor';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Ingresa un número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              StatefulBuilder(
                builder: (context, setDialogState) => DropdownButtonFormField<String>(
                  value: estadoGasto,
                  decoration: const InputDecoration(
                    labelText: 'Tipo',
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'fijo', child: Text('Fijo')),
                    DropdownMenuItem(value: 'variable', child: Text('Variable')),
                  ],
                  onChanged: (value) {
                    setDialogState(() {
                      estadoGasto = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                Navigator.of(context).pop(true);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      try {
        final gasto = Gasto(
          nombreGasto: nombreController.text,
          valorGasto: double.parse(valorController.text),
          estadoGasto: estadoGasto,
        );

        await _easySaveService.createGasto(_userId!, gasto);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gasto creado exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
          _loadGastos();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _deleteGasto(Gasto gasto) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Gasto'),
        content: Text('¿Estás seguro de eliminar "${gasto.nombreGasto}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      try {
        await _easySaveService.deleteGasto(gasto.id!);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gasto eliminado'),
              backgroundColor: Colors.orange,
            ),
          );
          _loadGastos();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('💸 Mis Gastos'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(_errorMessage!),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _loadGastos,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadGastos,
                  child: _gastos.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inbox,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No hay gastos registrados',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: _showAddGastoDialog,
                                icon: const Icon(Icons.add),
                                label: const Text('Añadir Gasto'),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _gastos.length,
                          itemBuilder: (context, index) {
                            final gasto = _gastos[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.red.shade100,
                                  child: Icon(
                                    Icons.arrow_downward,
                                    color: Colors.red.shade700,
                                  ),
                                ),
                                title: Text(
                                  gasto.nombreGasto,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  gasto.estadoGasto.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: gasto.estadoGasto == 'fijo'
                                        ? Colors.blue
                                        : Colors.orange,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '\$${gasto.valorGasto.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _deleteGasto(gasto),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddGastoDialog,
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
      ),
    );
  }
}
