class ResearchProduct {
  final String id;
  final String titulo;
  final String? descripcion;
  final String? autores;
  final String? fechaPublicacion;
  final String? revista;
  final String? volumen;
  final String? paginas;
  final String? doi;
  final String? url;
  final String? keywords;
  final String? resumen;
  final String tipologia;
  final String? imagen;

  ResearchProduct({
    required this.id,
    required this.titulo,
    this.descripcion,
    this.autores,
    this.fechaPublicacion,
    this.revista,
    this.volumen,
    this.paginas,
    this.doi,
    this.url,
    this.keywords,
    this.resumen,
    required this.tipologia,
    this.imagen,
  });

  factory ResearchProduct.fromJson(Map<String, dynamic> json) {
    return ResearchProduct(
      id: json['cod_producto']?.toString() ?? json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      titulo: json['txt_nme_prod'] ?? json['titulo'] ?? json['nombre'] ?? 'Sin título',
      descripcion: json['descripcion'] ?? json['resumen'] ?? json['observaciones'],
      autores: json['integrante'] ?? json['autores'] ?? json['nombreCompleto'] ?? 'Sin autor',
      fechaPublicacion: _buildFecha(json),
      revista: json['txt_nme_revista'] ?? json['revista'] ?? json['nombrePublicacion'],
      volumen: json['txt_volumen_revista']?.toString() ?? json['volumen']?.toString(),
      paginas: _buildPaginas(json),
      doi: json['txt_doi'] ?? json['doi'],
      url: json['txt_web_producto'] ?? json['url'] ?? json['urlExterna'],
      keywords: json['palabrasClave'] ?? json['keywords'],
      resumen: json['resumen'] ?? json['descripcion'],
      tipologia: json['tipologia'] ?? '',
      imagen: json['imagen'],
    );
  }

  static String _buildFecha(Map<String, dynamic> json) {
    final anio = json['nro_ano_presenta']?.toString() ?? json['anio']?.toString();
    final mes = json['nme_mes']?.toString() ?? json['mes']?.toString();
    
    if (anio != null && mes != null) {
      return '$mes $anio';
    } else if (anio != null) {
      return anio;
    }
    return json['fechaPublicacion']?.toString() ?? json['fecha']?.toString() ?? 'Sin fecha';
  }

  static String _buildPaginas(Map<String, dynamic> json) {
    final inicial = json['txt_pagina_inicial']?.toString();
    final final_ = json['txt_pagina_final']?.toString();
    
    if (inicial != null && final_ != null) {
      return '$inicial-$final_';
    } else if (inicial != null) {
      return inicial;
    }
    return json['paginas']?.toString() ?? json['paginaInicio']?.toString() ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'autores': autores,
      'fechaPublicacion': fechaPublicacion,
      'revista': revista,
      'volumen': volumen,
      'paginas': paginas,
      'doi': doi,
      'url': url,
      'keywords': keywords,
      'resumen': resumen,
      'tipologia': tipologia,
      'imagen': imagen,
    };
  }

  @override
  String toString() {
    return 'ResearchProduct{id: $id, titulo: $titulo, tipologia: $tipologia}';
  }
}