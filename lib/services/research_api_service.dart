import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/research_product.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => 'ApiException: $message';
}

class ResearchApiService {
  static const Duration _timeout = Duration(seconds: 30);
  
  static String get _baseUrl => dotenv.env['API_BASE_URL'] ?? '';
  static String get _groupId => dotenv.env['GROUP_ID'] ?? '';

  /// Obtiene productos de investigación por tipología
  static Future<List<ResearchProduct>> getResearchProducts(String tipologia) async {
    try {
      if (_baseUrl.isEmpty || _groupId.isEmpty) {
        throw ApiException('Configuración de API no encontrada en archivo .env');
      }

      // Construir URL con parámetros
      final Uri url = Uri.parse(_baseUrl).replace(
        queryParameters: {
          'nroIdGrupo': _groupId,
          'sglTipologia': tipologia,
        },
      );
      
      print('🌐 Realizando petición a: $url');
      
      // Realizar petición HTTP con headers mejorados
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json',
          'User-Agent': 'Flutter App 1.0',
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
          'Access-Control-Allow-Headers': 'Content-Type',
        },
      ).timeout(
        _timeout,
        onTimeout: () {
          throw ApiException('Tiempo de espera agotado. Verifique su conexión a internet.');
        },
      );

      print('📊 Status Code: ${response.statusCode}');
      print('📦 Content-Type: ${response.headers['content-type']}');
      print('📝 Response Length: ${response.body.length} caracteres');

      if (response.statusCode == 200) {
        final String responseBody = response.body.trim();
        
        // Log del contenido de respuesta (primeros 200 caracteres)
        final preview = responseBody.length > 200 
            ? '${responseBody.substring(0, 200)}...' 
            : responseBody;
        print('📄 Response Preview: $preview');
        
        // Verificar si la respuesta está vacía
        if (responseBody.isEmpty) {
          print('⚠️ Respuesta vacía del servidor');
          return [];
        }

        // Verificar si la respuesta es null literal
        if (responseBody == 'null') {
          print('⚠️ Respuesta null del servidor - No hay datos para tipología: $tipologia');
          return [];
        }

        try {
          final dynamic decodedJson = json.decode(responseBody);
          
          // Si la respuesta es null después del decode
          if (decodedJson == null) {
            print('⚠️ JSON decodificado es null');
            return [];
          }

          List<dynamic> jsonList = [];
          
          // Manejar diferentes estructuras de respuesta
          if (decodedJson is Map<String, dynamic>) {
            print('📋 Respuesta es un Map con keys: ${decodedJson.keys.toList()}');
            
            // Buscar arrays comunes en respuestas de APIs
            if (decodedJson.containsKey('data') && decodedJson['data'] is List) {
              jsonList = decodedJson['data'] as List<dynamic>;
            } else if (decodedJson.containsKey('items') && decodedJson['items'] is List) {
              jsonList = decodedJson['items'] as List<dynamic>;
            } else if (decodedJson.containsKey('results') && decodedJson['results'] is List) {
              jsonList = decodedJson['results'] as List<dynamic>;
            } else if (decodedJson.containsKey('productos') && decodedJson['productos'] is List) {
              jsonList = decodedJson['productos'] as List<dynamic>;
            } else {
              // Si no es un wrapper conocido, tratar el objeto como un item único
              jsonList = [decodedJson];
            }
          } else if (decodedJson is List<dynamic>) {
            print('📋 Respuesta es una List directa con ${decodedJson.length} elementos');
            jsonList = decodedJson;
          } else {
            print('⚠️ Formato de respuesta no reconocido: ${decodedJson.runtimeType}');
            return [];
          }

          print('🔢 Procesando ${jsonList.length} elementos...');

          // Convertir elementos a ResearchProduct
          final List<ResearchProduct> products = [];
          
          for (int i = 0; i < jsonList.length; i++) {
            final item = jsonList[i];
            
            if (item == null) {
              print('⚠️ Item $i es null, saltando...');
              continue;
            }
            
            if (item is! Map<String, dynamic>) {
              print('⚠️ Item $i no es un Map válido: ${item.runtimeType}, saltando...');
              continue;
            }

            try {
              // Enriquecer item con información adicional
              final Map<String, dynamic> enrichedItem = Map<String, dynamic>.from(item);
              
              // Agregar ID único si no existe
              if (!enrichedItem.containsKey('id') || enrichedItem['id'] == null || enrichedItem['id'].toString().isEmpty) {
                enrichedItem['id'] = '${tipologia}_${DateTime.now().millisecondsSinceEpoch}_$i';
              }
              
              // Agregar tipología
              enrichedItem['tipologia'] = tipologia;
              
              // Crear producto
              final product = ResearchProduct.fromJson(enrichedItem);
              products.add(product);
              
              print('✅ Producto $i procesado: ${product.titulo.substring(0, product.titulo.length > 50 ? 50 : product.titulo.length)}...');
              
            } catch (e) {
              print('❌ Error procesando item $i: $e');
              print('📄 Item content: $item');
              continue;
            }
          }

          print('🎉 ${products.length} productos procesados exitosamente para tipología: $tipologia');
          return products;
          
        } catch (e) {
          print('❌ Error decodificando JSON: $e');
          print('📄 Raw response: ${responseBody.substring(0, responseBody.length > 500 ? 500 : responseBody.length)}');
          throw ApiException('Error al procesar respuesta del servidor: ${e.toString()}');
        }
        
      } else if (response.statusCode == 404) {
        print('📭 No se encontraron datos (404) para tipología: $tipologia');
        return [];
      } else if (response.statusCode == 403) {
        throw ApiException('Acceso denegado (403). Verificar permisos de API.');
      } else if (response.statusCode == 500) {
        throw ApiException('Error interno del servidor (500). Intente más tarde.');
      } else {
        print('❌ Error HTTP ${response.statusCode}: ${response.reasonPhrase}');
        throw ApiException(
          'Error del servidor (${response.statusCode}): ${response.reasonPhrase}',
          response.statusCode,
        );
      }
      
    } on ApiException {
      rethrow;
    } catch (e) {
      print('❌ Error general en petición HTTP: $e');
      
      // Identificar tipos específicos de errores
      if (e.toString().contains('Failed to fetch') || 
          e.toString().contains('XMLHttpRequest error') ||
          e.toString().contains('CORS')) {
        throw ApiException(
          'Error de CORS o conectividad. Para resolver esto:\n'
          '1. Ejecute la aplicación en un dispositivo móvil o desktop\n'
          '2. O use un proxy CORS para desarrollo web\n'
          '3. Detalles técnicos: ${e.toString()}'
        );
      } else if (e.toString().contains('timeout') || e.toString().contains('Timeout')) {
        throw ApiException('Tiempo de espera agotado. Verifique su conexión a internet.');
      } else {
        throw ApiException('Error de red: ${e.toString()}');
      }
    }
  }

  /// Obtiene un producto específico por ID y tipología
  static Future<ResearchProduct?> getResearchProductById(
    String id, 
    String tipologia,
  ) async {
    try {
      final products = await getResearchProducts(tipologia);
      
      for (final product in products) {
        if (product.id == id) {
          return product;
        }
      }
      
      return null;
    } catch (e) {
      rethrow;
    }
  }

  /// Verifica la disponibilidad de la API
  static Future<bool> checkApiHealth() async {
    try {
      // Intentar con una tipología común
      await getResearchProducts('ART_E');
      return true;
    } catch (e) {
      return false;
    }
  }
}