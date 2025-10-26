# 💰 Implementación de EasySave - Gestión de Ingresos y Gastos

## 📋 Descripción General

EasySave es un módulo de gestión financiera personal integrado en la aplicación Flutter que permite a los usuarios autenticados administrar sus ingresos y gastos de manera eficiente. El sistema se conecta a un backend Spring Boot que proporciona las APIs REST necesarias para las operaciones CRUD.

## 🎯 Características Implementadas

### 1. **Sistema de Autenticación JWT**
- Login y registro de usuarios
- Almacenamiento seguro de tokens con `flutter_secure_storage`
- Almacenamiento de datos de usuario con `shared_preferences`
- Redirección automática a `/easysave` después del login

### 2. **Dashboard EasySave**
- Vista general del estado financiero del usuario
- Resumen de ingresos totales y gastos totales
- Cálculo automático del balance (verde si es positivo, rojo si es negativo)
- Lista de los 3 ingresos más recientes
- Lista de los 3 gastos más recientes
- Botones de acceso rápido para agregar ingresos y gastos
- Navegación a listas completas

### 3. **Gestión de Ingresos**
- Vista completa de todos los ingresos del usuario
- Clasificación por tipo: Fijo o Variable
- Operaciones CRUD:
  - ✅ **Crear**: Formulario con validación (nombre, valor, tipo)
  - ✅ **Leer**: Lista con detalles y totales
  - ✅ **Eliminar**: Con confirmación de seguridad
- Pull-to-refresh para actualizar datos
- Estados vacíos con instrucciones

### 4. **Gestión de Gastos**
- Vista completa de todos los gastos del usuario
- Clasificación por tipo: Fijo o Variable
- Operaciones CRUD:
  - ✅ **Crear**: Formulario con validación (nombre, valor, tipo)
  - ✅ **Leer**: Lista con detalles y totales
  - ✅ **Eliminar**: Con confirmación de seguridad
- Pull-to-refresh para actualizar datos
- Estados vacíos con instrucciones

### 5. **Modo Oscuro**
- Toggle de tema en el AppBar de todas las pantallas EasySave
- Persistencia del tema seleccionado con `shared_preferences`
- Tema claro y oscuro con Material Design 3
- Cambio instantáneo sin reiniciar la app

## 🏗️ Arquitectura

### Modelos de Datos

#### `Ingreso`
```dart
class Ingreso {
  final int? id;
  final String nombreIngreso;
  final double valorIngreso;
  final String estadoIngreso; // 'fijo' o 'variable'
}
```

#### `Gasto`
```dart
class Gasto {
  final int? id;
  final String nombreGasto;
  final double valorGasto;
  final String estadoGasto; // 'fijo' o 'variable'
}
```

#### `UsuarioCompleto`
```dart
class UsuarioCompleto {
  final int id;
  final String username;
  final String email;
  final String rol;
  final List<Ingreso> ingresos;
  final List<Gasto> gastos;

  // Propiedades calculadas
  double get totalIngresos;
  double get totalGastos;
  double get balance; // totalIngresos - totalGastos
  List<Ingreso> get ingresosFijos;
  List<Ingreso> get ingresosVariables;
  List<Gasto> get gastosFijos;
  List<Gasto> get gastosVariables;
}
```

### Servicios

#### `EasySaveService` (Singleton)
Gestiona todas las comunicaciones con el backend:

**Endpoints de Usuario:**
- `GET /api/v1/usuario-service/usuarios/{id}` - Obtener datos completos del usuario

**Endpoints de Ingresos:**
- `GET /api/v1/usuario-service/usuarios/{id}/ingresos` - Listar ingresos
- `POST /api/v1/usuario-service/usuarios/{id}/ingresos` - Crear ingreso
- `PUT /api/v1/usuario-service/ingresos/{id}` - Actualizar ingreso
- `DELETE /api/v1/usuario-service/ingresos/{id}` - Eliminar ingreso

**Endpoints de Gastos:**
- `GET /api/v1/usuario-service/usuarios/{id}/gastos` - Listar gastos
- `POST /api/v1/usuario-service/usuarios/{id}/gastos` - Crear gasto
- `PUT /api/v1/usuario-service/gastos/{id}` - Actualizar gasto
- `DELETE /api/v1/usuario-service/gastos/{id}` - Eliminar gasto

#### `ThemeProvider` (ChangeNotifier)
Gestiona el estado global del tema:
- `ThemeMode themeMode` - Modo actual del tema
- `bool isDarkMode` - Verificador del modo oscuro
- `toggleTheme()` - Alternar entre claro y oscuro
- `loadThemeMode()` - Cargar tema guardado al inicio

### Navegación

```
/login ──────> /easysave (después de login exitoso)
                    │
                    ├── /easysave/ingresos
                    │       └── Formulario de nuevo ingreso
                    │       └── Confirmación de eliminación
                    │
                    └── /easysave/gastos
                            └── Formulario de nuevo gasto
                            └── Confirmación de eliminación
```

## 📦 Dependencias

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Navegación
  go_router: ^14.2.7
  
  # HTTP Client
  http: ^1.2.2
  
  # Almacenamiento
  shared_preferences: ^2.2.2
  flutter_secure_storage: ^9.0.0
  
  # Gestión de Estado
  provider: ^6.1.1
  
  # Variables de entorno
  flutter_dotenv: ^5.2.1
```

## 🚀 Configuración del Backend

El backend debe estar corriendo en:
```
http://localhost:8080
```

### Variables de Entorno (`.env`)

```env
API_BASE_URL=http://localhost:8080/api/v1
AUTH_ENDPOINT=/auth
USUARIO_SERVICE_ENDPOINT=/usuario-service
```

## 📱 Pantallas Implementadas

### 1. EasySave Dashboard (`easysave_screen.dart`)

**Funcionalidades:**
- Saludo personalizado con nombre de usuario
- Card de resumen financiero con:
  - Balance total (con color dinámico)
  - Total de ingresos
  - Total de gastos
- Botones de acción rápida
- Listas de últimos 3 ingresos y gastos
- AppBar con:
  - Toggle de tema (☀️/🌙)
  - Botón de perfil
  - Botón de logout

### 2. Pantalla de Ingresos (`ingresos_screen.dart`)

**Funcionalidades:**
- Lista completa de ingresos ordenados
- Card por ingreso mostrando:
  - Icono (flecha arriba verde)
  - Nombre del ingreso
  - Tipo (Fijo/Variable) con badge
  - Valor en formato moneda
  - Botón de eliminar
- FloatingActionButton para agregar
- Dialog de creación con validación
- Confirmación antes de eliminar
- Pull-to-refresh
- Estado vacío con mensaje

### 3. Pantalla de Gastos (`gastos_screen.dart`)

**Funcionalidades:**
- Lista completa de gastos ordenados
- Card por gasto mostrando:
  - Icono (flecha abajo roja)
  - Nombre del gasto
  - Tipo (Fijo/Variable) con badge
  - Valor en formato moneda
  - Botón de eliminar
- FloatingActionButton para agregar
- Dialog de creación con validación
- Confirmación antes de eliminar
- Pull-to-refresh
- Estado vacío con mensaje

## 🎨 Temas

### Tema Claro
- Primary Color: Blue (Material)
- Card: Blanco con elevación
- Background: Gris claro
- Text: Negro/Gris oscuro

### Tema Oscuro
- Primary Color: Blue (Material)
- Card: Gris oscuro con elevación
- Background: Negro
- Text: Blanco/Gris claro

## 🔐 Seguridad

### Almacenamiento de Tokens
- **Access Token**: Almacenado en `flutter_secure_storage` (encriptado)
- **Token Type**: Almacenado en `flutter_secure_storage` (encriptado)

### Almacenamiento de Datos de Usuario
- **Username**: `shared_preferences`
- **Email**: `shared_preferences`
- **User ID**: `shared_preferences`
- **Rol**: `shared_preferences`

### Headers de Autorización
Todas las peticiones a endpoints protegidos incluyen:
```
Authorization: Bearer <access_token>
```

## 📊 Flujo de Datos

```
Usuario interactúa con UI
         ↓
    Widget State
         ↓
  EasySaveService (HTTP)
         ↓
    Backend API
         ↓
  PostgreSQL Database
         ↓
    JSON Response
         ↓
   Modelo de Datos
         ↓
  setState() / Rebuild
         ↓
     UI Actualizada
```

## 🧪 Testing

### Escenarios de Prueba

1. **Autenticación:**
   - Login con credenciales válidas → Redirección a `/easysave`
   - Login con credenciales inválidas → Mensaje de error
   - Logout → Limpiar storage y redirigir a `/login`

2. **Gestión de Ingresos:**
   - Crear ingreso fijo
   - Crear ingreso variable
   - Eliminar ingreso (con confirmación)
   - Validación de campos vacíos
   - Validación de valores numéricos

3. **Gestión de Gastos:**
   - Crear gasto fijo
   - Crear gasto variable
   - Eliminar gasto (con confirmación)
   - Validación de campos vacíos
   - Validación de valores numéricos

4. **Tema:**
   - Toggle de tema claro a oscuro
   - Persistencia del tema al reiniciar app
   - Tema aplicado en todas las pantallas

5. **Navegación:**
   - Protección de rutas sin autenticación
   - Navegación entre pantallas EasySave
   - Botones de retroceso

## 🐛 Manejo de Errores

### Códigos de Error HTTP
- **401 Unauthorized**: Token inválido o expirado → Redirigir a login
- **404 Not Found**: Recurso no encontrado → Mensaje al usuario
- **500 Internal Server Error**: Error del servidor → Reintentar
- **Network Error**: Sin conexión → Mensaje de error

### Estados de UI
- Loading: `CircularProgressIndicator`
- Error: Icono de error + mensaje + botón de reintentar
- Vacío: Icono + mensaje + botón de acción
- Éxito: SnackBar con confirmación

## 📝 Próximas Mejoras

### Funcionalidades Pendientes
- [ ] Editar ingresos y gastos existentes
- [ ] Filtros por fecha y tipo
- [ ] Gráficos de ingresos vs gastos
- [ ] Exportar datos a PDF/Excel
- [ ] Categorías personalizadas
- [ ] Metas de ahorro
- [ ] Notificaciones de recordatorio
- [ ] Búsqueda de transacciones
- [ ] Historial de cambios

### Optimizaciones
- [ ] Caché local con SQLite
- [ ] Paginación de listas largas
- [ ] Sincronización offline
- [ ] Animaciones de transición
- [ ] Validación de formularios mejorada

## 👥 Soporte

Para problemas o preguntas:
1. Verificar que el backend esté corriendo en `localhost:8080`
2. Revisar los logs en la consola de Flutter
3. Verificar tokens en `flutter_secure_storage`
4. Limpiar datos con `flutter clean` si es necesario

---

**Versión:** 1.0.0  
**Última actualización:** 2024  
**Autor:** Equipo de Desarrollo EasySave
