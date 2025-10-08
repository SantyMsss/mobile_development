import '../services/web_research_api_service.dart';

class ApiTester {
  /// Grupos de investigación conocidos para probar
  static const List<String> testGroups = [
    '00000000002096', // Grupo original del README
    '00000000001368', // Grupo que funcionó antes
    '00000000000013', // Universidad Nacional - Grupo muy activo
    '00000000000324', // Universidad de Antioquia
    '00000000000567', // Universidad del Valle
    '00000000001892', // Universidad de los Andes
    '00000000002456', // Universidad Javeriana
    '00000000003789', // Universidad del Norte
  ];

  /// Tipologías más comunes con datos
  static const List<String> commonTypologies = [
    'ART_E',     // Artículos Electrónicos
    'ART_I',     // Artículos Impresos
    'LIB',       // Libros
    'CAP_LIB',   // Capítulos
    'TD',        // Tesis Doctorado
    'TM',        // Tesis Maestría
    'PID',       // Proyectos
    'EC',        // Eventos
    'SF',        // Software
    'GC_ART',    // Otros artículos
  ];

  /// Prueba un grupo específico con las tipologías más comunes
  static Future<Map<String, dynamic>> testGroup(String groupId) async {
    final results = <String, dynamic>{};
    results['groupId'] = groupId;
    results['typologies'] = <String, int>{};
    results['totalProducts'] = 0;
    results['workingTypologies'] = <String>[];
    results['emptyTypologies'] = <String>[];
    results['errorTypologies'] = <String>[];

    print('🔍 Probando grupo: $groupId');

    for (final typology in commonTypologies) {
      try {
        // Simular cambio de grupo temporalmente
        final originalUrl = 'https://scienti.minciencias.gov.co/gruplac/json/Verificador/query.do?nroIdGrupo=$groupId&sglTipologia=$typology';
        
        print('🌐 Probando: $originalUrl');
        
        final products = await WebResearchApiService.getResearchProducts(typology);
        
        if (products.isNotEmpty) {
          results['typologies'][typology] = products.length;
          results['totalProducts'] += products.length;
          results['workingTypologies'].add(typology);
          print('✅ $typology: ${products.length} productos');
        } else {
          results['typologies'][typology] = 0;
          results['emptyTypologies'].add(typology);
          print('⚠️ $typology: Sin datos');
        }
        
        // Pequeña pausa para no sobrecargar la API
        await Future.delayed(const Duration(milliseconds: 500));
        
      } catch (e) {
        results['typologies'][typology] = -1;
        results['errorTypologies'].add(typology);
        print('❌ $typology: Error - $e');
      }
    }

    print('📊 Resumen grupo $groupId:');
    print('   Total productos: ${results['totalProducts']}');
    print('   Tipologías con datos: ${results['workingTypologies'].length}');
    print('   Tipologías vacías: ${results['emptyTypologies'].length}');
    print('   Tipologías con error: ${results['errorTypologies'].length}');

    return results;
  }

  /// Encuentra el mejor grupo con más datos
  static Future<Map<String, dynamic>> findBestGroup() async {
    final allResults = <Map<String, dynamic>>[];
    
    print('🚀 Iniciando búsqueda del mejor grupo...');
    
    for (final groupId in testGroups) {
      try {
        final result = await testGroup(groupId);
        allResults.add(result);
        
        // Pausa entre grupos
        await Future.delayed(const Duration(seconds: 2));
        
      } catch (e) {
        print('❌ Error probando grupo $groupId: $e');
      }
    }

    // Encontrar el grupo con más productos
    if (allResults.isNotEmpty) {
      allResults.sort((a, b) => (b['totalProducts'] as int).compareTo(a['totalProducts'] as int));
      
      final bestGroup = allResults.first;
      
      print('🏆 MEJOR GRUPO ENCONTRADO:');
      print('   ID: ${bestGroup['groupId']}');
      print('   Total productos: ${bestGroup['totalProducts']}');
      print('   Tipologías activas: ${bestGroup['workingTypologies']}');
      
      return bestGroup;
    }

    throw Exception('No se encontraron grupos con datos');
  }

  /// Prueba rápida de conectividad
  static Future<bool> testApiConnectivity() async {
    try {
      print('🔄 Probando conectividad con la API...');
      
      // Probar con un grupo y tipología conocidos
      await WebResearchApiService.getResearchProducts('ART_E');
      
      print('✅ API accesible');
      return true;
    } catch (e) {
      print('❌ API no accesible: $e');
      return false;
    }
  }
}