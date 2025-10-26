# 🔐 Implementación de Autenticación JWT en Flutter

## 📋 Descripción

Sistema de autenticación completo con JWT (JSON Web Token) que se conecta al backend **EasySave Service** desarrollado en Spring Boot.

---

## 🏗️ Arquitectura Implementada

### **Modelos de Datos** (`lib/models/auth_models.dart`)
- `RegisterRequest`: Solicitud de registro de usuario
- `LoginRequest`: Solicitud de inicio de sesión
- `AuthResponse`: Respuesta del servidor con token JWT
- `User`: Modelo de usuario autenticado

### **Servicios**

#### **StorageService** (`lib/services/storage_service.dart`)
Gestiona el almacenamiento local de datos:

**Almacenamiento Seguro (FlutterSecureStorage):**
- ✅ `access_token`: Token JWT de autenticación
- ✅ `token_type`: Tipo de token (Bearer)

**Almacenamiento NO Sensible (SharedPreferences):**
- ✅ `username`: Nombre de usuario
- ✅ `email`: Correo electrónico
- ✅ `user_id`: ID del usuario
- ✅ `rol`: Rol del usuario (USER/ADMIN)

#### **AuthService** (`lib/services/auth_service.dart`)
Gestiona la comunicación con el backend:

**Endpoints disponibles:**
- `POST /api/v1/auth/register`: Registro de nuevo usuario
- `POST /api/v1/auth/login`: Inicio de sesión
- `GET /api/v1/auth/test`: Verificación de token

---

## 📱 Pantallas Implementadas

### 1. **LoginScreen** (`lib/views/auth/login_screen.dart`)
Pantalla de inicio de sesión con:
- ✅ Validación de formularios
- ✅ Manejo de estados de carga
- ✅ Mensajes de error personalizados
- ✅ Toggle de visibilidad de contraseña
- ✅ Navegación a registro

### 2. **RegisterScreen** (`lib/views/auth/register_screen.dart`)
Pantalla de registro con:
- ✅ Validación de email
- ✅ Confirmación de contraseña
- ✅ Validación de longitud mínima
- ✅ Feedback visual de errores

### 3. **ProfileScreen** (`lib/views/profile/profile_screen.dart`)
Pantalla de evidencia que muestra:
- ✅ **Nombre de usuario** (desde SharedPreferences)
- ✅ **Email** (desde SharedPreferences)
- ✅ **ID de usuario** (desde SharedPreferences)
- ✅ **Estado del token** (presente/ausente)
- ✅ **Tipo de token** (Bearer)
- ✅ Botón "Verificar Token" (llama a `/api/v1/auth/test`)
- ✅ Botón "Cerrar Sesión" (elimina todos los datos)
- ✅ Información técnica sobre almacenamiento

---

## 🔒 Seguridad Implementada

### **Protección de Rutas**
El router (`lib/routes/app_router.dart`) implementa:

```dart
redirect: (context, state) async {
  final storage = StorageService();
  final isLoggedIn = await storage.isLoggedIn();
  
  // Redirige a /login si no está autenticado
  if (!isLoggedIn && !isGoingToLogin && !isGoingToRegister) {
    return '/login';
  }
  
  // Redirige a / si ya está autenticado
  if (isLoggedIn && (isGoingToLogin || isGoingToRegister)) {
    return '/';
  }
  
  return null;
}
```

### **Almacenamiento Seguro**

#### **FlutterSecureStorage** (Datos sensibles)
- Encriptación a nivel de sistema operativo
- Ideal para tokens y credenciales
- No accesible desde otras apps

#### **SharedPreferences** (Datos no sensibles)
- Almacenamiento persistente simple
- Ideal para preferencias y datos públicos
- Fácil acceso y modificación

---

## 🚀 Flujo de Autenticación

### **1. Registro de Usuario**
```
Usuario → RegisterScreen → AuthService.register() 
  → Backend (POST /auth/register)
  → AuthResponse con token
  → StorageService.saveAuthResponse()
  → SharedPreferences (username, email, id, rol)
  → FlutterSecureStorage (token, token_type)
  → Navegación a HomeScreen
```

### **2. Inicio de Sesión**
```
Usuario → LoginScreen → AuthService.login()
  → Backend (POST /auth/login)
  → AuthResponse con token
  → StorageService.saveAuthResponse()
  → Datos guardados en almacenamiento local
  → Navegación a HomeScreen
```

### **3. Verificación de Sesión**
```
App Inicia → Router.redirect()
  → StorageService.isLoggedIn()
  → Verifica existencia de token y datos de usuario
  → Si existe → HomeScreen
  → Si no existe → LoginScreen
```

### **4. Cierre de Sesión**
```
Usuario → ProfileScreen → Botón "Cerrar Sesión"
  → Confirmación (Dialog)
  → AuthService.logout()
  → StorageService.clearSession()
  → Elimina token de FlutterSecureStorage
  → Elimina datos de SharedPreferences
  → Navegación a LoginScreen
```

---

## 🔧 Configuración Requerida

### **1. Dependencias en `pubspec.yaml`**
```yaml
dependencies:
  shared_preferences: ^2.2.2
  flutter_secure_storage: ^9.0.0
  http: ^1.1.0
  go_router: ^14.2.7
```

### **2. Backend URL**
Actualiza la URL en `lib/services/auth_service.dart`:
```dart
static const String baseUrl = 'http://localhost:8080/api/v1/auth';
```

Para dispositivo físico, usa la IP de tu máquina:
```dart
static const String baseUrl = 'http://192.168.1.X:8080/api/v1/auth';
```

### **3. Permisos Android**
Ya configurado en `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

---

## 📊 Evidencia de Cumplimiento

### ✅ **Almacenamiento Local Requerido**

| Tipo de Dato | Storage | Ubicación | Estado |
|--------------|---------|-----------|--------|
| `username` | SharedPreferences | NO sensible | ✅ Implementado |
| `email` | SharedPreferences | NO sensible | ✅ Implementado |
| `user_id` | SharedPreferences | NO sensible | ✅ Implementado |
| `rol` | SharedPreferences | NO sensible | ✅ Implementado |
| `access_token` | FlutterSecureStorage | Sensible | ✅ Implementado |
| `token_type` | FlutterSecureStorage | Sensible | ✅ Implementado |

### ✅ **Vista de Evidencia (ProfileScreen)**

Cumple con todos los requisitos:
- ✅ Muestra **nombre** leído desde SharedPreferences
- ✅ Muestra **email** leído desde SharedPreferences
- ✅ Indicador de sesión: "Token presente" / "Sin token"
- ✅ Botón "Cerrar sesión" que elimina datos y tokens
- ✅ Información técnica sobre almacenamiento
- ✅ Botón de verificación de token (prueba `/auth/test`)

---

## 🧪 Cómo Probar

### **1. Iniciar el Backend**
```bash
cd EasySaveService
mvn spring-boot:run
```

### **2. Ejecutar la App Flutter**
```bash
flutter run
```

### **3. Flujo de Prueba Completo**

**a) Registro:**
1. Abre la app (redirige automáticamente a `/login`)
2. Toca "¿No tienes cuenta? Regístrate"
3. Completa el formulario:
   - Usuario: `testuser`
   - Email: `test@example.com`
   - Contraseña: `password123`
4. Toca "Registrarse"
5. Verifica que redirige al home

**b) Ver Perfil:**
1. En HomeScreen, toca el ícono de perfil (arriba derecha)
2. Verifica que se muestran:
   - Nombre de usuario
   - Email
   - ID
   - Estado: "✓ Token Presente"

**c) Verificar Token:**
1. En ProfileScreen, toca "Verificar Token"
2. Debe mostrar: "✅ Token válido y autenticado"

**d) Cerrar Sesión:**
1. Toca "Cerrar Sesión"
2. Confirma en el diálogo
3. Verifica que redirige a `/login`
4. Verifica que los datos se eliminaron

**e) Login:**
1. Ingresa las credenciales creadas
2. Toca "Iniciar Sesión"
3. Verifica que redirige al home

---

## 🎯 Endpoints del Backend

### **Base URL**
```
http://localhost:8080/api/v1/auth
```

### **Registro**
```http
POST /register
Content-Type: application/json

{
  "username": "juan",
  "correo": "juan@example.com",
  "password": "password123",
  "rol": "USER"
}
```

**Response (201):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "type": "Bearer",
  "id": 1,
  "username": "juan",
  "correo": "juan@example.com",
  "rol": "USER"
}
```

### **Login**
```http
POST /login
Content-Type: application/json

{
  "username": "juan",
  "password": "password123"
}
```

**Response (200):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "type": "Bearer",
  "id": 1,
  "username": "juan",
  "correo": "juan@example.com",
  "rol": "USER"
}
```

### **Test de Autenticación**
```http
GET /test
Authorization: Bearer {token}
```

**Response (200):**
```json
{
  "message": "¡Autenticación exitosa!",
  "status": "authenticated"
}
```

---

## 📸 Capturas de Pantalla

### LoginScreen
Interfaz de inicio de sesión con validación de formularios.

### RegisterScreen
Formulario de registro con confirmación de contraseña.

### ProfileScreen
Pantalla de evidencia mostrando:
- Datos del usuario (SharedPreferences)
- Estado del token (FlutterSecureStorage)
- Información técnica de almacenamiento

---

## 🔍 Logs de Debugging

El sistema incluye logs detallados en consola:

```
🔐 Intentando login: testuser
📊 Status Code: 200
✅ Login exitoso: testuser
💾 Datos de usuario guardados: testuser
🔑 Token guardado de forma segura
✅ Sesión guardada completamente
👤 Usuario logueado: true
```

---

## ✅ Checklist de Implementación

- [x] Modelos de datos (RegisterRequest, LoginRequest, AuthResponse, User)
- [x] StorageService con SharedPreferences
- [x] StorageService con FlutterSecureStorage
- [x] AuthService con endpoints del backend
- [x] LoginScreen con validación
- [x] RegisterScreen con validación
- [x] ProfileScreen con evidencia de almacenamiento
- [x] Protección de rutas con go_router
- [x] Botón de perfil en HomeScreen
- [x] Funcionalidad de cerrar sesión
- [x] Verificación de token
- [x] Manejo de errores
- [x] Logs de debugging

---

## 🎓 Conceptos Aplicados

### **1. Singleton Pattern**
```dart
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();
}
```

### **2. Async/Await**
Toda la comunicación con el backend y almacenamiento es asíncrona.

### **3. State Management**
Uso de `setState()` para manejar estados de carga, errores y datos.

### **4. Form Validation**
Validación de formularios con `GlobalKey<FormState>`.

### **5. Secure Storage**
Diferenciación entre datos sensibles y no sensibles.

---

**Desarrollador:** Santiago Martínez Serna  
**Proyecto:** EasySave - Gestión de Ingresos y Gastos  
**Framework:** Flutter 3.10.0+  
**Backend:** Spring Boot + JWT  
**Fecha:** Octubre 2025
