## Taller 2 - Navegación y Widgets Avanzados

### 📋 Requisitos Implementados

#### 1. ✅ Navegación y paso de parámetros
- **go_router** implementado para navegación
- **Paso de parámetros** desde pantalla principal a pantalla secundaria (nombre y método de navegación)
- **Diferencias demostradas**:
  - `go()`: Reemplaza toda la pila de navegación (sin botón atrás automático)
  - `push()`: Agrega a la pila (mantiene botón atrás)
  - `pushReplacement()`: Reemplaza pantalla actual (sin regreso a la anterior)

#### 2. ✅ Widgets implementados
- **GridView**: 8 elementos con colores diferentes y animaciones
- **TabBar**: 3 pestañas (Inicio, Grid, Info) con contenido diferente
- **BottomNavigationBar**: Navegación adicional (widget extra elegido)
- **Stack**: Texto superpuesto sobre imagen en pantalla secundaria

#### 3. ✅ Ciclo de vida registrado
Todos los métodos registran en consola con comentarios explicativos:
- `initState()`: Inicialización una sola vez
- `didChangeDependencies()`: Dependencias disponibles
- `build()`: Construcción/reconstrucción del widget
- `setState()`: Notificación de cambio de estado
- `dispose()`: Limpieza de recursos

### 📱 Estructura del Proyecto
```
lib/
├── main.dart                 # Configuración go_router y app principal
└── screens/
    ├── home_screen.dart      # Pantalla principal con TabBar y widgets
    └── details_screen.dart   # Pantalla secundaria con parámetros
```

### 🔍 Características Destacadas

**Pantalla Principal (HomeScreen):**
- TabBar con 3 secciones diferentes
- GridView colorido con 8 elementos
- BottomNavigationBar funcional
- Botones para demostrar diferentes tipos de navegación
- Logs del ciclo de vida en consola

**Pantalla Secundaria (DetailsScreen):**
- Recibe y muestra parámetros de navegación
- Stack con imagen y texto superpuesto
- Explicación visual de diferencias de navegación
- Contador con setState() para demostrar ciclo de vida

### 🖥️ Logs de Consola Esperados
Al ejecutar la app verás en consola:
```
🟢 HomeScreen: initState() - Widget creado e inicializado
🔵 HomeScreen: didChangeDependencies() - Dependencias disponibles
🟡 HomeScreen: build() - Widget siendo construido/reconstruido
🔴 HomeScreen: setState() - Estado cambiando, se ejecutará build()
🔴 HomeScreen: dispose() - Widget siendo eliminado, limpiando recursos
```

### ▶️ Ejecución
```bash
flutter pub get
flutter run
```

### 🎯 Funcionalidades de Prueba
1. **Cambiar título**: Botón que alterna AppBar y muestra logs de setState()
2. **Navegación GO**: Sin botón atrás automático
3. **Navegación PUSH**: Con botón atrás
4. **Navegación REPLACE**: Reemplaza pantalla actual
5. **TabBar**: Cambiar entre pestañas
6. **GridView**: Visualizar elementos coloridos
7. **BottomNavigation**: Navegar desde la barra inferior

---
**Autor**: Santiago Martinez Serna  
**Taller**: Navegación y Widgets Avanzados con Flutter

## 📷 Capturas (galería)

Las capturas incluidas muestran pasos claves de la app: la pantalla principal, la navegación con los distintos métodos (`go`, `push`, `pushReplacement`) y los logs en la consola que evidencian el ciclo de vida.

Coloca las imágenes en la raíz del proyecto o en una carpeta (ej. `docs/` o `assets/screenshots/`) y actualiza las rutas si es necesario.

| Archivo | Descripción |
|---|---|
| `docs/screenshots/image.png` | Inicio de la aplicación (HomeScreen con TabBar) |
| `docs/screenshots/image-1.png` | Resultado de navegar con `go()` (pantalla de destino) |
| `docs/screenshots/image-2.png` | Consola: logs producidos tras `go()` |
| `docs/screenshots/image-3.png` | Acción: Añadir KM (interacción de la app) |
| `docs/screenshots/image-4.png` | Consola: logs después de interacción (Añadir KM) |
| `docs/screenshots/image-5.png` | Acción: Regresar (ejemplo de flujo) |
| `docs/screenshots/image-6.png` | Consola: logs del regreso |
| `docs/screenshots/image-7.png` | Navegar con `push()` (pantalla destino) |
| `docs/screenshots/image-8.png` | Consola: logs tras `push()` |
| `docs/screenshots/image-9.png` | Interacción: Añadir KM (otra captura) |
| `docs/screenshots/image-10.png` | Consola: logs relacionados |
| `docs/screenshots/image-11.png` | Consola: otro registro relevante |
| `docs/screenshots/image-12.png` | Acciones de regreso/estado previo |
| `docs/screenshots/image-13.png` | Navegar con `pushReplacement()` (pantalla destino) |
| `docs/screenshots/image-14.png` | Consola: logs tras `pushReplacement()` |
| `docs/screenshots/image-15.png` | Interacción posterior a replace |
| `docs/screenshots/image-16.png` | Consola: logs posteriores |
| `docs/screenshots/image-17.png` | Intento de regresar tras `replace` (debe no permitir volver) |
| `docs/screenshots/image-18.png` | Consola: evidencia del comportamiento |

Si deseas que inserte las imágenes en la carpeta `docs/screenshots/` y actualice las rutas automáticamente, indícamelo y las crearé (necesitarás subir los archivos si aún no están en el repositorio).

