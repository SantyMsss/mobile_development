import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/storage_service.dart';
import '../../services/auth_service.dart';
import '../../models/auth_models.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final StorageService _storage = StorageService();
  final AuthService _authService = AuthService();

  User? _user;
  bool _hasToken = false;
  String? _tokenType;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);

    try {
      final user = await _storage.getUser();
      final hasToken = await _storage.hasToken();
      final tokenType = await _storage.getTokenType();

      setState(() {
        _user = user;
        _hasToken = hasToken;
        _tokenType = tokenType;
        _isLoading = false;
      });
    } catch (e) {
      print('Error cargando datos: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleLogout() async {
    // Mostrar diálogo de confirmación
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
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sesión cerrada correctamente'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  Future<void> _testToken() async {
    setState(() => _isLoading = true);

    try {
      final isValid = await _authService.testAuthentication();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isValid 
                ? '✅ Token válido y autenticado' 
                : '❌ Token inválido o expirado'
            ),
            backgroundColor: isValid ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al verificar token: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil y Sesión'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Header con avatar
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.blue.shade700,
                          Colors.blue.shade900,
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _user?.username ?? 'Usuario',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _user?.rol ?? 'ROL',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Información del usuario
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Información de Cuenta',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Card de Nombre de Usuario
                        _InfoCard(
                          icon: Icons.person_outline,
                          title: 'Nombre de Usuario',
                          subtitle: _user?.username ?? 'No disponible',
                          source: 'SharedPreferences',
                        ),
                        const SizedBox(height: 12),

                        // Card de Email
                        _InfoCard(
                          icon: Icons.email_outlined,
                          title: 'Correo Electrónico',
                          subtitle: _user?.correo ?? 'No disponible',
                          source: 'SharedPreferences',
                        ),
                        const SizedBox(height: 12),

                        // Card de ID
                        _InfoCard(
                          icon: Icons.fingerprint,
                          title: 'ID de Usuario',
                          subtitle: _user?.id.toString() ?? 'No disponible',
                          source: 'SharedPreferences',
                        ),
                        const SizedBox(height: 24),

                        // Estado de Token
                        const Text(
                          'Estado de Autenticación',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Card de Token
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _hasToken 
                              ? Colors.green.shade50 
                              : Colors.red.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _hasToken 
                                ? Colors.green.shade200 
                                : Colors.red.shade200,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _hasToken ? Icons.check_circle : Icons.cancel,
                                color: _hasToken ? Colors.green : Colors.red,
                                size: 40,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _hasToken 
                                        ? '✓ Token Presente' 
                                        : '✗ Sin Token',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: _hasToken 
                                          ? Colors.green.shade900 
                                          : Colors.red.shade900,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Tipo: ${_tokenType ?? 'N/A'}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Almacenado en: FlutterSecureStorage',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade600,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Botones de acción
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: _hasToken ? _testToken : null,
                            icon: const Icon(Icons.verified_user),
                            label: const Text('Verificar Token'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton.icon(
                            onPressed: _handleLogout,
                            icon: const Icon(Icons.logout),
                            label: const Text('Cerrar Sesión'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Información técnica
                        Card(
                          color: Colors.grey.shade100,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.info_outline, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Información Técnica',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                _TechInfoRow(
                                  label: 'Almacenamiento No Sensible:',
                                  value: 'SharedPreferences',
                                ),
                                _TechInfoRow(
                                  label: 'Almacenamiento Seguro:',
                                  value: 'FlutterSecureStorage',
                                ),
                                _TechInfoRow(
                                  label: 'Datos Almacenados:',
                                  value: 'nombre, email, id, rol',
                                ),
                                _TechInfoRow(
                                  label: 'Datos Seguros:',
                                  value: 'access_token, token_type',
                                ),
                              ],
                            ),
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
}

// Widget para mostrar información de usuario
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String source;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.source,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.blue.shade700),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Fuente: $source',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget para información técnica
class _TechInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _TechInfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
