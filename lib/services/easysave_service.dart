import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/easysave_models.dart';
import 'auth_service.dart';

/// Servicio para gestionar ingresos y gastos - EasySave API
class EasySaveService {
  // Singleton pattern
  static final EasySaveService _instance = EasySaveService._internal();
  factory EasySaveService() => _instance;
  EasySaveService._internal();

  final AuthService _authService = AuthService();

  // URL base del backend
  static const String baseUrl = 'http://localhost:8080/api/v1/usuario-service';

  // ========== USUARIOS ==========

  /// Obtener usuario por ID con sus ingresos y gastos
  Future<UsuarioCompleto> getUsuario(int userId) async {
    try {
      final headers = await _authService.getAuthHeaders();
      
      final response = await http.get(
        Uri.parse('$baseUrl/usuarios/$userId'),
        headers: headers,
      );

      print('📊 Get Usuario - Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final usuario = UsuarioCompleto.fromJson(jsonDecode(response.body));
        print('✅ Usuario obtenido: ${usuario.username}');
        print('💵 Ingresos: ${usuario.ingresos.length}');
        print('💸 Gastos: ${usuario.gastos.length}');
        return usuario;
      } else {
        throw Exception('Error al obtener usuario');
      }
    } catch (e) {
      print('❌ Error obteniendo usuario: $e');
      rethrow;
    }
  }

  // ========== INGRESOS ==========

  /// Listar ingresos de un usuario
  Future<List<Ingreso>> getIngresos(int userId) async {
    try {
      final headers = await _authService.getAuthHeaders();
      
      final response = await http.get(
        Uri.parse('$baseUrl/usuarios/$userId/ingresos'),
        headers: headers,
      );

      print('📊 Get Ingresos - Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final ingresos = data.map((json) => Ingreso.fromJson(json)).toList();
        print('✅ ${ingresos.length} ingresos obtenidos');
        return ingresos;
      } else {
        throw Exception('Error al obtener ingresos');
      }
    } catch (e) {
      print('❌ Error obteniendo ingresos: $e');
      rethrow;
    }
  }

  /// Crear nuevo ingreso
  Future<Ingreso> createIngreso(int userId, Ingreso ingreso) async {
    try {
      final headers = await _authService.getAuthHeaders();
      
      final response = await http.post(
        Uri.parse('$baseUrl/usuarios/$userId/ingresos'),
        headers: headers,
        body: jsonEncode(ingreso.toJson()),
      );

      print('📊 Create Ingreso - Status: ${response.statusCode}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final nuevoIngreso = Ingreso.fromJson(jsonDecode(response.body));
        print('✅ Ingreso creado: ${nuevoIngreso.nombreIngreso}');
        return nuevoIngreso;
      } else {
        throw Exception('Error al crear ingreso');
      }
    } catch (e) {
      print('❌ Error creando ingreso: $e');
      rethrow;
    }
  }

  /// Actualizar ingreso existente
  Future<Ingreso> updateIngreso(int ingresoId, Ingreso ingreso) async {
    try {
      final headers = await _authService.getAuthHeaders();
      
      final response = await http.put(
        Uri.parse('$baseUrl/ingresos/$ingresoId'),
        headers: headers,
        body: jsonEncode(ingreso.toJson()),
      );

      print('📊 Update Ingreso - Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final ingresoActualizado = Ingreso.fromJson(jsonDecode(response.body));
        print('✅ Ingreso actualizado: ${ingresoActualizado.nombreIngreso}');
        return ingresoActualizado;
      } else {
        throw Exception('Error al actualizar ingreso');
      }
    } catch (e) {
      print('❌ Error actualizando ingreso: $e');
      rethrow;
    }
  }

  /// Eliminar ingreso
  Future<void> deleteIngreso(int ingresoId) async {
    try {
      final headers = await _authService.getAuthHeaders();
      
      final response = await http.delete(
        Uri.parse('$baseUrl/ingresos/$ingresoId'),
        headers: headers,
      );

      print('📊 Delete Ingreso - Status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('✅ Ingreso eliminado');
      } else {
        throw Exception('Error al eliminar ingreso');
      }
    } catch (e) {
      print('❌ Error eliminando ingreso: $e');
      rethrow;
    }
  }

  // ========== GASTOS ==========

  /// Listar gastos de un usuario
  Future<List<Gasto>> getGastos(int userId) async {
    try {
      final headers = await _authService.getAuthHeaders();
      
      final response = await http.get(
        Uri.parse('$baseUrl/usuarios/$userId/gastos'),
        headers: headers,
      );

      print('📊 Get Gastos - Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final gastos = data.map((json) => Gasto.fromJson(json)).toList();
        print('✅ ${gastos.length} gastos obtenidos');
        return gastos;
      } else {
        throw Exception('Error al obtener gastos');
      }
    } catch (e) {
      print('❌ Error obteniendo gastos: $e');
      rethrow;
    }
  }

  /// Crear nuevo gasto
  Future<Gasto> createGasto(int userId, Gasto gasto) async {
    try {
      final headers = await _authService.getAuthHeaders();
      
      final response = await http.post(
        Uri.parse('$baseUrl/usuarios/$userId/gastos'),
        headers: headers,
        body: jsonEncode(gasto.toJson()),
      );

      print('📊 Create Gasto - Status: ${response.statusCode}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final nuevoGasto = Gasto.fromJson(jsonDecode(response.body));
        print('✅ Gasto creado: ${nuevoGasto.nombreGasto}');
        return nuevoGasto;
      } else {
        throw Exception('Error al crear gasto');
      }
    } catch (e) {
      print('❌ Error creando gasto: $e');
      rethrow;
    }
  }

  /// Actualizar gasto existente
  Future<Gasto> updateGasto(int gastoId, Gasto gasto) async {
    try {
      final headers = await _authService.getAuthHeaders();
      
      final response = await http.put(
        Uri.parse('$baseUrl/gastos/$gastoId'),
        headers: headers,
        body: jsonEncode(gasto.toJson()),
      );

      print('📊 Update Gasto - Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final gastoActualizado = Gasto.fromJson(jsonDecode(response.body));
        print('✅ Gasto actualizado: ${gastoActualizado.nombreGasto}');
        return gastoActualizado;
      } else {
        throw Exception('Error al actualizar gasto');
      }
    } catch (e) {
      print('❌ Error actualizando gasto: $e');
      rethrow;
    }
  }

  /// Eliminar gasto
  Future<void> deleteGasto(int gastoId) async {
    try {
      final headers = await _authService.getAuthHeaders();
      
      final response = await http.delete(
        Uri.parse('$baseUrl/gastos/$gastoId'),
        headers: headers,
      );

      print('📊 Delete Gasto - Status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('✅ Gasto eliminado');
      } else {
        throw Exception('Error al eliminar gasto');
      }
    } catch (e) {
      print('❌ Error eliminando gasto: $e');
      rethrow;
    }
  }
}
