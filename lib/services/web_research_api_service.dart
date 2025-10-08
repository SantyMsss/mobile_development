import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/research_product.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => 'ApiException: $message';
}

class WebResearchApiService {
  static const Duration _timeout = Duration(seconds: 30);
  
  static String get _baseUrl => dotenv.env['API_BASE_URL'] ?? 'https://scienti.minciencias.gov.co/gruplac/json/Verificador/query.do';
  static String get _groupId => dotenv.env['GROUP_ID'] ?? '00000000002096';

  /// Proxy CORS para desarrollo web
  static String _getCorsProxyUrl(String originalUrl) {
    // Para desarrollo, podemos usar un proxy CORS público
    // En producción, esto debería ser tu propio proxy
    return 'https://api.allorigins.win/get?url=${Uri.encodeComponent(originalUrl)}';
  }

  /// Obtiene productos de investigación usando proxy para web
  static Future<List<ResearchProduct>> getResearchProducts(String tipologia) async {
    try {
      if (_baseUrl.isEmpty || _groupId.isEmpty) {
        throw ApiException('Configuración de API no encontrada en archivo .env');
      }

      // Construir URL original
      final originalUrl = '$_baseUrl?nroIdGrupo=$_groupId&sglTipologia=$tipologia';
      
      String finalUrl;
      Map<String, String> headers;

      if (kIsWeb) {
        // En web, usar proxy CORS
        finalUrl = _getCorsProxyUrl(originalUrl);
        headers = {
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json',
        };
        print('🌐 [WEB] Usando proxy CORS: $finalUrl');
      } else {
        // En móvil/desktop, usar URL directa
        finalUrl = originalUrl;
        headers = {
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json',
          'User-Agent': 'Flutter App 1.0',
        };
        print('🌐 [MÓVIL] URL directa: $finalUrl');
      }
      
      final response = await http.get(
        Uri.parse(finalUrl),
        headers: headers,
      ).timeout(
        _timeout,
        onTimeout: () {
          throw ApiException('Tiempo de espera agotado. Verifique su conexión a internet.');
        },
      );

      print('📊 Status Code: ${response.statusCode}');
      print('📦 Content-Type: ${response.headers['content-type']}');

      if (response.statusCode == 200) {
        String responseBody;
        
        if (kIsWeb && finalUrl.contains('allorigins.win')) {
          // Si usamos el proxy, extraer el contenido real
          final proxyResponse = json.decode(response.body);
          if (proxyResponse['status']['http_code'] == 200) {
            responseBody = proxyResponse['contents'];
          } else {
            throw ApiException('Error en proxy: ${proxyResponse['status']['error'] ?? 'Error desconocido'}');
          }
        } else {
          responseBody = response.body;
        }

        responseBody = responseBody.trim();
        
        print('📝 Response Length: ${responseBody.length} caracteres');
        
        if (responseBody.isEmpty || responseBody == 'null') {
          print('⚠️ No hay datos disponibles para tipología: $tipologia');
          return [];
        }

        try {
          final dynamic decodedJson = json.decode(responseBody);
          
          if (decodedJson == null) {
            print('⚠️ JSON decodificado es null');
            return [];
          }

          List<dynamic> jsonList = [];
          
          if (decodedJson is Map<String, dynamic>) {
            print('📋 Respuesta es un Map con keys: ${decodedJson.keys.toList()}');
            
            // Buscar arrays en diferentes posibles estructuras
            if (decodedJson.containsKey('data') && decodedJson['data'] is List) {
              jsonList = decodedJson['data'] as List<dynamic>;
            } else if (decodedJson.containsKey('items') && decodedJson['items'] is List) {
              jsonList = decodedJson['items'] as List<dynamic>;
            } else if (decodedJson.containsKey('results') && decodedJson['results'] is List) {
              jsonList = decodedJson['results'] as List<dynamic>;
            } else if (decodedJson.containsKey('productos') && decodedJson['productos'] is List) {
              jsonList = decodedJson['productos'] as List<dynamic>;
            } else {
              // Tratar el objeto como un item único
              jsonList = [decodedJson];
            }
          } else if (decodedJson is List<dynamic>) {
            print('📋 Respuesta es una List directa con ${decodedJson.length} elementos');
            jsonList = decodedJson;
          } else {
            print('⚠️ Formato de respuesta no reconocido: ${decodedJson.runtimeType}');
            return [];
          }

          final List<ResearchProduct> products = [];
          
          for (int i = 0; i < jsonList.length; i++) {
            final item = jsonList[i];
            
            if (item == null || item is! Map<String, dynamic>) {
              continue;
            }

            try {
              final Map<String, dynamic> enrichedItem = Map<String, dynamic>.from(item);
              
              // Agregar ID único si no existe
              if (!enrichedItem.containsKey('id') || enrichedItem['id'] == null || enrichedItem['id'].toString().isEmpty) {
                // Crear ID más estable basado en contenido
                final titulo = enrichedItem['titulo']?.toString() ?? '';
                final autores = enrichedItem['autores']?.toString() ?? '';
                final fecha = enrichedItem['fechaPublicacion']?.toString() ?? enrichedItem['anio']?.toString() ?? '';
                
                // Crear hash simple pero consistente
                final contentHash = (titulo + autores + fecha).hashCode.abs();
                enrichedItem['id'] = '${tipologia}_${contentHash}_$i';
              }
              
              enrichedItem['tipologia'] = tipologia;
              
              final product = ResearchProduct.fromJson(enrichedItem);
              products.add(product);
              
            } catch (e) {
              print('❌ Error procesando item $i: $e');
              continue;
            }
          }

          print('🎉 ${products.length} productos procesados exitosamente para tipología: $tipologia');
          return products;
          
        } catch (e) {
          print('❌ Error decodificando JSON: $e');
          throw ApiException('Error al procesar respuesta del servidor: ${e.toString()}');
        }
        
      } else {
        print('❌ Error HTTP ${response.statusCode}: ${response.reasonPhrase}');
        
        if (response.statusCode == 404) {
          return [];
        } else if (response.statusCode == 403) {
          throw ApiException('Acceso denegado (403). Verificar permisos de API.');
        } else if (response.statusCode == 500) {
          throw ApiException('Error interno del servidor (500). Intente más tarde.');
        } else {
          throw ApiException(
            'Error del servidor (${response.statusCode}): ${response.reasonPhrase}',
            response.statusCode,
          );
        }
      }
      
    } on ApiException {
      rethrow;
    } catch (e) {
      print('❌ Error general: $e');
      
      if (e.toString().contains('Failed to fetch') || 
          e.toString().contains('XMLHttpRequest error') ||
          e.toString().contains('CORS')) {
        
        if (kIsWeb) {
          throw ApiException(
            'Error de CORS en navegador web. Recomendaciones:\n'
            '• Ejecutar en Windows/móvil para mejor compatibilidad\n'
            '• O usar proxy CORS en desarrollo\n'
            'Error técnico: ${e.toString()}'
          );
        } else {
          throw ApiException('Error de conectividad: ${e.toString()}');
        }
      } else if (e.toString().contains('timeout')) {
        throw ApiException('Tiempo de espera agotado. Verifique su conexión a internet.');
      } else {
        throw ApiException('Error de red: ${e.toString()}');
      }
    }
  }

  /// Obtiene un producto específico por ID
  static Future<ResearchProduct?> getResearchProductById(
    String id, 
    String tipologia,
  ) async {
    try {
      print('🔍 Buscando producto con ID: $id en tipología: $tipologia');
      final products = await getResearchProducts(tipologia);
      
      for (final product in products) {
        if (product.id == id) {
          print('✅ Producto encontrado: ${product.titulo}');
          return product;
        }
      }
      
      print('❌ Producto con ID $id no encontrado');
      return null;
    } catch (e) {
      print('❌ Error buscando producto por ID: $e');
      rethrow;
    }
  }

  /// Verifica la disponibilidad de la API
  static Future<bool> checkApiHealth() async {
    try {
      print('🏥 Verificando salud de la API...');
      await getResearchProducts('ART_E');
      print('✅ API funcionando correctamente');
      return true;
    } catch (e) {
      print('❌ API no disponible: $e');
      return false;
    }
  }
}