import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/auth_models.dart';

/// Servicio de almacenamiento para datos sensibles y no sensibles
class StorageService {
  // Singleton pattern
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  // Almacenamiento seguro para tokens (datos sensibles)
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Claves para almacenamiento
  static const String _keyAccessToken = 'access_token';
  static const String _keyTokenType = 'token_type';
  static const String _keyUserId = 'user_id';
  static const String _keyUsername = 'username';
  static const String _keyEmail = 'email';
  static const String _keyRol = 'rol';

  // ========== ALMACENAMIENTO SEGURO (Tokens) ==========

  /// Guardar token de acceso de forma segura
  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: _keyAccessToken, value: token);
    print('🔐 Token guardado de forma segura');
  }

  /// Obtener token de acceso
  Future<String?> getAccessToken() async {
    final token = await _secureStorage.read(key: _keyAccessToken);
    print('🔑 Token recuperado: ${token != null ? "presente" : "ausente"}');
    return token;
  }

  /// Verificar si existe un token
  Future<bool> hasToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Guardar tipo de token (Bearer)
  Future<void> saveTokenType(String type) async {
    await _secureStorage.write(key: _keyTokenType, value: type);
  }

  /// Obtener tipo de token
  Future<String?> getTokenType() async {
    return await _secureStorage.read(key: _keyTokenType);
  }

  // ========== ALMACENAMIENTO NO SENSIBLE (Datos de usuario) ==========

  /// Guardar datos del usuario autenticado
  Future<void> saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyUserId, user.id);
    await prefs.setString(_keyUsername, user.username);
    await prefs.setString(_keyEmail, user.correo);
    await prefs.setString(_keyRol, user.rol);
    print('💾 Datos de usuario guardados: ${user.username}');
  }

  /// Obtener ID del usuario
  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyUserId);
  }

  /// Obtener nombre de usuario
  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  /// Obtener email del usuario
  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }

  /// Obtener rol del usuario
  Future<String?> getRol() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRol);
  }

  /// Obtener usuario completo
  Future<User?> getUser() async {
    final id = await getUserId();
    final username = await getUsername();
    final email = await getEmail();
    final rol = await getRol();

    if (id == null || username == null || email == null || rol == null) {
      return null;
    }

    return User(
      id: id,
      username: username,
      correo: email,
      rol: rol,
    );
  }

  // ========== GUARDAR RESPUESTA COMPLETA DE AUTH ==========

  /// Guardar toda la respuesta de autenticación
  Future<void> saveAuthResponse(AuthResponse response) async {
    await saveAccessToken(response.token);
    await saveTokenType(response.type);
    await saveUserData(User.fromAuthResponse(response));
    print('✅ Sesión guardada completamente');
  }

  // ========== CERRAR SESIÓN ==========

  /// Eliminar todos los datos de sesión
  Future<void> clearSession() async {
    // Eliminar tokens seguros
    await _secureStorage.delete(key: _keyAccessToken);
    await _secureStorage.delete(key: _keyTokenType);

    // Eliminar datos de usuario
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUsername);
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyRol);

    print('🚪 Sesión cerrada - Todos los datos eliminados');
  }

  /// Eliminar todo el almacenamiento (para casos excepcionales)
  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('🧹 Todo el almacenamiento ha sido limpiado');
  }

  // ========== VERIFICACIÓN DE SESIÓN ==========

  /// Verificar si el usuario tiene sesión activa
  Future<bool> isLoggedIn() async {
    final hasToken = await this.hasToken();
    final user = await getUser();
    final isValid = hasToken && user != null;
    print('👤 Usuario logueado: $isValid');
    return isValid;
  }

  /// Obtener información resumida de la sesión
  Future<Map<String, dynamic>> getSessionInfo() async {
    final hasToken = await this.hasToken();
    final user = await getUser();
    final tokenType = await getTokenType();

    return {
      'isLoggedIn': hasToken && user != null,
      'hasToken': hasToken,
      'tokenType': tokenType,
      'user': user?.toJson(),
    };
  }
}
