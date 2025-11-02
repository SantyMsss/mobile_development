class UniversidadFb {
  final String id;
  final String nombre;
  final String nit;
  final String direccion;
  final String telefono;
  final String paginaWeb;

  UniversidadFb({
    required this.id,
    required this.nombre,
    required this.nit,
    required this.direccion,
    required this.telefono,
    required this.paginaWeb,
  });

  factory UniversidadFb.fromMap(String id, Map<String, dynamic> data) {
    return UniversidadFb(
      id: id,
      nombre: data['nombre'] ?? '',
      nit: data['nit'] ?? '',
      direccion: data['direccion'] ?? '',
      telefono: data['telefono'] ?? '',
      paginaWeb: data['pagina_web'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'nit': nit,
      'direccion': direccion,
      'telefono': telefono,
      'pagina_web': paginaWeb,
    };
  }
}
