# Sistema de Universidades con Firebase Firestore

### 📱 **Descripción Técnica**

Sistema completo de gestión de universidades implementado con **Firebase Firestore** que permite operaciones CRUD en tiempo real mediante una arquitectura reactiva basada en **Streams**.

**Arquitectura:** Model-Service-View con Streams para sincronización automática  
**Gestión de Estado:** StreamBuilder + StatefulWidget  
**Validaciones:** Funciones helper reutilizables con RegExp para URLs  

### 🏗️ **Modelo de Datos - Universidad Firebase**

```dart
class UniversidadFb {
  final String id;           // ID del documento en Firestore
  final String nombre;       // Nombre de la universidad
  final String nit;          // Número de identificación tributaria  
  final String direccion;    // Dirección completa
  final String telefono;     // Número de contacto
  final String paginaWeb;    // URL del sitio web

  UniversidadFb({required this.id, required this.nombre, required this.nit, 
                 required this.direccion, required this.telefono, required this.paginaWeb});

  // Conversión bidireccional con Firestore
  factory UniversidadFb.fromMap(String id, Map<String, dynamic> data) => UniversidadFb(
    id: id,
    nombre: data['nombre'] ?? '',
    nit: data['nit'] ?? '',
    direccion: data['direccion'] ?? '',
    telefono: data['telefono'] ?? '',
    paginaWeb: data['pagina_web'] ?? '',  // Mapeo desde Firebase
  );

  Map<String, dynamic> toMap() => {
    'nombre': nombre,
    'nit': nit,
    'direccion': direccion,
    'telefono': telefono,
    'pagina_web': paginaWeb,  // Mapeo a Firebase
  };
}
```

### 🔄 **Servicio con Streams (Tiempo Real)**

```dart
class UniversidadService {
  static final _ref = FirebaseFirestore.instance.collection('universidades');

  // Stream en tiempo real - Lista completa
  static Stream<List<UniversidadFb>> watchUniversidades() {
    return _ref.snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => UniversidadFb.fromMap(doc.id, doc.data())).toList()
    );
  }

  // Stream en tiempo real - Un documento
  static Stream<UniversidadFb?> watchUniversidadById(String id) {
    return _ref.doc(id).snapshots().map((doc) =>
      doc.exists ? UniversidadFb.fromMap(doc.id, doc.data()!) : null
    );
  }

  // CRUD Operations
  static Future<void> addUniversidad(UniversidadFb universidad) => _ref.add(universidad.toMap());
  static Future<void> updateUniversidad(UniversidadFb universidad) => _ref.doc(universidad.id).update(universidad.toMap());
  static Future<void> deleteUniversidad(String id) => _ref.doc(id).delete();
}
```

### ✅ **Sistema de Validaciones**

| Campo | Validaciones |
|-------|-------------|
| **Nombre** | No vacío • Mín. 3 caracteres |
| **NIT** | No vacío • Mín. 5 caracteres |
| **Dirección** | No vacío • Mín. 10 caracteres |
| **Teléfono** | No vacío • Mín. 7 caracteres • Debe contener números |
| **Página Web** | No vacío • http:// o https:// • RegExp de URL completa |

**Validación de URL (RegExp):**
```dart
String? _validarURL(String? value) {
  if (value == null || value.trim().isEmpty) return 'La página web es requerida';
  
  final url = value.trim().toLowerCase();
  if (!url.startsWith('http://') && !url.startsWith('https://')) {
    return 'La URL debe iniciar con http:// o https://';
  }
  
  final urlPattern = RegExp(
    r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    caseSensitive: false,
  );
  
  return urlPattern.hasMatch(url) ? null : 'URL inválida (ej: https://www.ejemplo.com)';
}
```

### 📱 **Pantallas Implementadas**

**1. Lista de Universidades** (`/universidadesFirebase`)
- Diseño responsive: Lista (móvil) / Grid 2 cols (tablet) / Grid 3 cols (desktop)
- StreamBuilder para actualización en tiempo real
- Cards con: Nombre, NIT, Dirección, Teléfono
- Acciones: Editar (tap en card), Eliminar (con confirmación), Crear (FAB)

**2. Formulario** (`/universidadesfb/create` y `/universidadesfb/edit/:id`)
- Modo dual: Crear (vacío) / Editar (con StreamBuilder)
- 2 Cards organizadas: "Información básica" + "Información de contacto"
- Validación en tiempo real con mensajes claros
- Helper text en campo URL: "Debe iniciar con http:// o https://"

### 🛣️ **Rutas**

```dart
GoRoute(path: '/universidadesFirebase', name: 'universidadesFirebase', builder: (_, __) => const UniversidadFbListView()),
GoRoute(path: '/universidadesfb/create', name: 'universidadesfb.create', builder: (_, __) => const UniversidadFbFormView()),
GoRoute(path: '/universidadesfb/edit/:id', name: 'universidades.edit', builder: (_, state) => UniversidadFbFormView(id: state.pathParameters['id']!)),
```

### 🎯 **Flujo de Datos en Tiempo Real**

```
Usuario modifica dato → Service actualiza Firestore → Stream emite evento → StreamBuilder reconstruye UI → Cambio visible instantáneamente
```

**Ventajas:**
- ⚡ Sincronización automática entre dispositivos
- 🔄 Sin necesidad de refresh manual
- 📊 Escalable y mantenible
- ✅ Validaciones robustas
- 📱 Responsive design


**📅 Fecha de Desarrollo**: Noviembre - 2 - 2025  
**🏫 Institución**: Unidad Central del Valle (UCEVA)  
**📚 Materia**: Desarrollo Móvil  

