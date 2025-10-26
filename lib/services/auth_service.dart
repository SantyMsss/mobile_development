import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_models.dart';
import 'storage_service.dart';

/// Servicio de autenticación con el backend EasySave Service
class AuthService {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final StorageService _storage = StorageService();

  // URL base del backend
  static const String baseUrl = 'http://localhost:8080/api/v1/auth';

  // ========== REGISTRO ==========

  /// Registrar un nuevo usuario
  Future<AuthResponse> register({
    required String username,
    required String correo,
    required String password,
    String rol = 'USER',
  }) async {
    try {
      print('📝 Intentando registrar usuario: $username');

      final request = RegisterRequest(
        username: username,
        correo: correo,
        password: password,
        rol: rol,
      );

      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      print('📊 Status Code: ${response.statusCode}');

      if (response.statusCode == 201) {
        final authResponse = AuthResponse.fromJson(jsonDecode(response.body));
        
        // Guardar sesión
        await _storage.saveAuthResponse(authResponse);
        
        print('✅ Registro exitoso: ${authResponse.username}');
        return authResponse;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Error en el registro');
      }
    } catch (e) {
      print('❌ Error en registro: $e');
      rethrow;
    }
  }

  // ========== LOGIN ==========

  /// Iniciar sesión
  Future<AuthResponse> login({
    required String username,
    required String password,
  }) async {
    try {
      print('🔐 Intentando login: $username');

      final request = LoginRequest(
        username: username,
        password: password,
      );

      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      print('📊 Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(jsonDecode(response.body));
        
        // Guardar sesión
        await _storage.saveAuthResponse(authResponse);
        
        print('✅ Login exitoso: ${authResponse.username}');
        return authResponse;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Credenciales inválidas');
      }
    } catch (e) {
      print('❌ Error en login: $e');
      rethrow;
    }
  }

  // ========== TEST DE AUTENTICACIÓN ==========

  /// Verificar si el token es válido
  Future<bool> testAuthentication() async {
    try {
      final token = await _storage.getAccessToken();
      
      if (token == null) {
        print('⚠️ No hay token para verificar');
        return false;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/test'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('📊 Test Auth Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('✅ Token válido');
        return true;
      } else {
        print('❌ Token inválido o expirado');
        return false;
      }
    } catch (e) {
      print('❌ Error al verificar token: $e');
      return false;
    }
  }

  // ========== CERRAR SESIÓN ==========

  /// Cerrar sesión del usuario
  Future<void> logout() async {
    await _storage.clearSession();
    print('👋 Sesión cerrada correctamente');
  }

  // ========== OBTENER HEADERS CON TOKEN ==========

  /// Obtener headers con autorización para peticiones protegidas
  Future<Map<String, String>> getAuthHeaders() async {
    final token = await _storage.getAccessToken();
    
    if (token == null) {
      throw Exception('No hay token de autenticación');
    }

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // ========== VERIFICACIÓN DE SESIÓN ==========

  /// Verificar si el usuario está autenticado
  Future<bool> isAuthenticated() async {
    return await _storage.isLoggedIn();
  }

  /// Obtener usuario actual
  Future<User?> getCurrentUser() async {
    return await _storage.getUser();
  }
}
