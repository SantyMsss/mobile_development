import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/easysave_models.dart';
import '../../services/easysave_service.dart';
import '../../services/storage_service.dart';
import '../../providers/theme_provider.dart';
import '../../services/auth_service.dart';

class EasySaveScreen extends StatefulWidget {
  const EasySaveScreen({super.key});

  @override
  State<EasySaveScreen> createState() => _EasySaveScreenState();
}

class _EasySaveScreenState extends State<EasySaveScreen> {
  final EasySaveService _easySaveService = EasySaveService();
  final StorageService _storage = StorageService();
  final AuthService _authService = AuthService();

  UsuarioCompleto? _usuario;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userId = await _storage.getUserId();
      
      if (userId == null) {
        throw Exception('No se encontró el ID de usuario');
      }

      final usuario = await _easySaveService.getUsuario(userId);
      
      setState(() {
        _usuario = usuario;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await _authService.logout();
      if (mounted) {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('💰 EasySave'),
        actions: [
          // Toggle tema
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: isDark ? 'Modo Claro' : 'Modo Oscuro',
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
          // Perfil
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'Perfil',
            onPressed: () {
              context.push('/profile');
            },
          ),
          // Cerrar sesión
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar Sesión',
            onPressed: _handleLogout,
          ),
        ],
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
                        onPressed: _loadUserData,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadUserData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header con saludo
                          _buildHeader(),
                          const SizedBox(height: 24),

                          // Resumen financiero
                          _buildFinancialSummary(),
                          const SizedBox(height: 24),

                          // Botones de acción
                          _buildActionButtons(),
                          const SizedBox(height: 24),

                          // Lista de ingresos recientes
                          _buildIngresosSection(),
                          const SizedBox(height: 24),

                          // Lista de gastos recientes
                          _buildGastosSection(),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }

  Widget _buildHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                _usuario!.username[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '¡Hola, ${_usuario!.username}!',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _usuario!.correo,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialSummary() {
    final balance = _usuario!.balance;
    final isPositive = balance >= 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'Balance Total',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${balance.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: isPositive ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryItem(
                    'Ingresos',
                    _usuario!.totalIngresos,
                    Colors.green,
                    Icons.arrow_upward,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryItem(
                    'Gastos',
                    _usuario!.totalGastos,
                    Colors.red,
                    Icons.arrow_downward,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, double value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '\$${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () async {
              final result = await context.push('/easysave/ingresos');
              if (result == true) _loadUserData();
            },
            icon: const Icon(Icons.add),
            label: const Text('Añadir Ingreso'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () async {
              final result = await context.push('/easysave/gastos');
              if (result == true) _loadUserData();
            },
            icon: const Icon(Icons.remove),
            label: const Text('Añadir Gasto'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIngresosSection() {
    final ingresos = _usuario!.ingresos;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Ingresos Recientes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () async {
                final result = await context.push('/easysave/ingresos');
                if (result == true) _loadUserData();
              },
              child: const Text('Ver todos'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (ingresos.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text('No hay ingresos registrados'),
              ),
            ),
          )
        else
          ...ingresos.take(3).map((ingreso) => _buildIngresoCard(ingreso)),
      ],
    );
  }

  Widget _buildGastosSection() {
    final gastos = _usuario!.gastos;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Gastos Recientes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () async {
                final result = await context.push('/easysave/gastos');
                if (result == true) _loadUserData();
              },
              child: const Text('Ver todos'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (gastos.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text('No hay gastos registrados'),
              ),
            ),
          )
        else
          ...gastos.take(3).map((gasto) => _buildGastoCard(gasto)),
      ],
    );
  }

  Widget _buildIngresoCard(Ingreso ingreso) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade100,
          child: Icon(Icons.arrow_upward, color: Colors.green.shade700),
        ),
        title: Text(ingreso.nombreIngreso),
        subtitle: Text(ingreso.estadoIngreso),
        trailing: Text(
          '\$${ingreso.valorIngreso.toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildGastoCard(Gasto gasto) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.red.shade100,
          child: Icon(Icons.arrow_downward, color: Colors.red.shade700),
        ),
        title: Text(gasto.nombreGasto),
        subtitle: Text(gasto.estadoGasto),
        trailing: Text(
          '\$${gasto.valorGasto.toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
