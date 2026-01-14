# Hospital Appointments App

Aplicación completa en Flutter para la gestión de pacientes y citas médicas en un hospital. Desarrollada siguiendo principios de **Clean Architecture**, **SOLID** y **Clean Code**.

## 📱 Características

- ✅ **Gestión de Pacientes**: Crear, editar, eliminar y buscar pacientes
- ✅ **Gestión de Citas**: Programar, modificar y cancelar citas médicas
- ✅ **Búsqueda Avanzada**: Filtrar citas por día o por mes
- ✅ **Base de Datos Local**: SQLite con patrón Repository
- ✅ **Interfaz Moderna**: Material Design 3 con tema claro y oscuro
- ✅ **Validación de Datos**: Formularios con validación completa
- ✅ **Arquitectura Limpia**: Separación clara de responsabilidades

## 🏗️ Arquitectura

La aplicación sigue **Clean Architecture** con la siguiente estructura:

```
lib/
├── core/                      # Código compartido
│   ├── constants/            # Constantes de la aplicación
│   ├── errors/               # Excepciones personalizadas
│   └── utils/                # Utilidades (validación, fechas)
├── data/                     # Capa de datos
│   ├── datasources/         # Acceso a SQLite
│   ├── models/              # Modelos de datos
│   └── repositories/        # Implementación de repositorios
├── domain/                   # Capa de dominio (lógica de negocio)
│   ├── entities/            # Entidades de negocio
│   └── repositories/        # Interfaces de repositorios
└── presentation/             # Capa de presentación (UI)
    ├── providers/           # Gestión de estado con Provider
    ├── screens/             # Pantallas de la aplicación
    └── widgets/             # Widgets reutilizables
```

### Principios Aplicados

- **Single Responsibility**: Cada clase tiene una única responsabilidad
- **Open/Closed**: Abierto para extensión, cerrado para modificación
- **Liskov Substitution**: Las implementaciones pueden sustituir a sus interfaces
- **Interface Segregation**: Interfaces específicas y cohesivas
- **Dependency Inversion**: Dependencias basadas en abstracciones

## 🚀 Instalación y Configuración

### Requisitos Previos

- **Flutter SDK**: 3.0.0 o superior
- **Dart SDK**: 3.0.0 o superior
- **Android Studio** / **VS Code** con extensiones de Flutter
- **Git** para clonar el repositorio

### Paso 1: Clonar el Repositorio

```bash
git clone <url-del-repositorio>
cd MovilCitacionesApp
```

### Paso 2: Instalar Dependencias

Abre una terminal en la raíz del proyecto y ejecuta:

```bash
flutter pub get
```

Esto descargará e instalará todas las dependencias necesarias:
- `provider`: Gestión de estado
- `sqflite`: Base de datos SQLite
- `intl`: Formateo de fechas
- `equatable`: Comparación de objetos

### Paso 3: Verificar la Instalación

Verifica que Flutter esté correctamente configurado:

```bash
flutter doctor
```

Soluciona cualquier problema que aparezca marcado con ❌.

## 🖥️ Ejecutar la Aplicación en VS Code

### Opción 1: Usando la Interfaz de VS Code

1. Abre el proyecto en **VS Code**
2. Conecta un dispositivo físico o inicia un emulador
3. Presiona `F5` o ve a **Run > Start Debugging**
4. Selecciona el dispositivo de destino cuando se te solicite

### Opción 2: Usando la Terminal

```bash
# Listar dispositivos disponibles
flutter devices

# Ejecutar en un dispositivo específico
flutter run -d <device-id>

# Ejecutar en modo debug (hot reload habilitado)
flutter run

# Ejecutar en modo release (optimizado)
flutter run --release
```

### Hot Reload durante el Desarrollo

Mientras la aplicación está corriendo en modo debug:
- Presiona `r` en la terminal para hacer **Hot Reload** (recarga rápida)
- Presiona `R` para hacer **Hot Restart** (reinicio completo)
- Presiona `q` para detener la aplicación

## 📱 Depuración en Emulador Android

### Crear una Máquina Virtual Android (AVD)

#### Opción 1: Desde Android Studio

1. **Abrir Android Studio**
2. Ir a **Tools > Device Manager** (o **AVD Manager** en versiones anteriores)
3. Click en **Create Device**
4. Seleccionar un tipo de dispositivo (ej: Pixel 6)
5. Click **Next**
6. Seleccionar una **System Image**:
   - Recomendado: **API 33** (Android 13) o superior
   - Si no está descargada, click en **Download** junto a la versión deseada
7. Click **Next**
8. Configurar opciones:
   - **AVD Name**: Dale un nombre descriptivo (ej: "Pixel_6_API_33")
   - **Startup orientation**: Portrait
   - Marcar **Enable Device Frame**
9. Click **Finish**

#### Opción 2: Desde la Línea de Comandos

```bash
# Listar AVDs disponibles
flutter emulators

# Crear un nuevo AVD
flutter emulators --create --name my_emulator

# Ver más opciones
sdkmanager --list
```

### Iniciar el Emulador

#### Desde Android Studio:
1. Abrir **Device Manager**
2. Click en el botón ▶️ junto al AVD creado

#### Desde la Terminal:
```bash
# Listar emuladores disponibles
flutter emulators

# Iniciar un emulador específico
flutter emulators --launch <emulator-id>
```

#### Desde VS Code:
1. Abre la **Command Palette** (`Ctrl+Shift+P`)
2. Escribe: `Flutter: Launch Emulator`
3. Selecciona el emulador de la lista

### Ejecutar la App en el Emulador

Una vez que el emulador esté corriendo:

```bash
flutter run
```

VS Code detectará automáticamente el emulador y ejecutará la app en él.

### Depurar en VS Code

1. **Colocar Breakpoints**: Click en el margen izquierdo del editor (número de línea)
2. **Iniciar Depuración**: Presiona `F5`
3. **Usar la Barra de Depuración**:
   - ▶️ Continue
   - ⏸️ Pause
   - ⏭️ Step Over
   - ⏬ Step Into
   - ⏫ Step Out
   - 🔄 Hot Reload
   - 🔴 Stop

4. **Ver Variables**: Panel de **Variables** en la vista de depuración
5. **Console**: Ver logs y salida en el **Debug Console**

### Inspeccionar la UI con Flutter Inspector

1. Iniciar la app en modo debug
2. En VS Code, abrir el **Flutter Inspector**:
   - Command Palette (`Ctrl+Shift+P`)
   - `Flutter: Open DevTools`
3. Usar las herramientas:
   - **Widget Inspector**: Ver árbol de widgets
   - **Performance**: Analizar rendimiento
   - **Network**: Monitorear peticiones
   - **Logging**: Ver logs de la app

## 📦 Generar APK (Android)

### APK de Debug (Para Pruebas)

```bash
flutter build apk --debug
```

El APK se generará en: `build/app/outputs/flutter-apk/app-debug.apk`

### APK de Release (Para Producción)

#### Paso 1: Configurar Firma de la App

1. Crear un keystore:
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. Crear archivo `android/key.properties`:
```properties
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=<ruta-al-keystore>
```

3. Modificar `android/app/build.gradle`:
```gradle
// Antes de android {}
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    ...
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

#### Paso 2: Generar APK

```bash
# APK Release
flutter build apk --release

# APK Split por ABI (más pequeños)
flutter build apk --split-per-abi --release
```

El APK se generará en: `build/app/outputs/flutter-apk/app-release.apk`

### App Bundle (Recomendado para Google Play)

```bash
flutter build appbundle --release
```

El bundle se generará en: `build/app/outputs/bundle/release/app-release.aab`

## 🍎 Generar IPA (iOS)

**Nota**: Necesitas una Mac con Xcode instalado y una cuenta de Apple Developer.

### Requisitos

- **Xcode** 14.0 o superior
- **CocoaPods** instalado
- **Cuenta de Apple Developer** (99 USD/año)

### Paso 1: Configurar Xcode

```bash
# Instalar pods
cd ios
pod install
cd ..
```

### Paso 2: Abrir en Xcode

```bash
open ios/Runner.xcworkspace
```

En Xcode:
1. Seleccionar el target **Runner**
2. Ir a **Signing & Capabilities**
3. Seleccionar tu **Team**
4. Configurar el **Bundle Identifier** (único)

### Paso 3: Generar IPA

#### Opción 1: Desde la Terminal

```bash
# Build para dispositivo iOS
flutter build ios --release

# Build con archivado para distribución
flutter build ipa --release
```

El IPA se generará en: `build/ios/ipa/`

#### Opción 2: Desde Xcode

1. Seleccionar **Any iOS Device (arm64)** como target
2. **Product > Archive**
3. Esperar a que termine el archivado
4. En el **Organizer**, seleccionar el archivo
5. Click **Distribute App**
6. Seleccionar método de distribución:
   - **App Store Connect**: Para publicar en App Store
   - **Ad Hoc**: Para distribución interna
   - **Enterprise**: Para distribución empresarial
   - **Development**: Para pruebas de desarrollo

### Subir a TestFlight / App Store

```bash
# Instalar herramienta de línea de comandos
xcode-select --install

# Subir IPA a App Store Connect
xcrun altool --upload-app -f build/ios/ipa/hospital_appointments.ipa -u <apple-id> -p <app-specific-password>
```

## 🗄️ Base de Datos

La aplicación utiliza **SQLite** como base de datos local con el siguiente esquema:

### Tabla: patients
```sql
CREATE TABLE patients (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  birth_date TEXT NOT NULL,
  phone TEXT NOT NULL,
  email TEXT NOT NULL,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);
```

### Tabla: appointments
```sql
CREATE TABLE appointments (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  patient_id INTEGER NOT NULL,
  appointment_date TEXT NOT NULL,
  notes TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (patient_id) REFERENCES patients (id) ON DELETE CASCADE
);
```

### Ubicación de la Base de Datos

- **Android**: `/data/data/com.example.hospital_appointments/databases/hospital_appointments.db`
- **iOS**: `Library/Application Support/hospital_appointments.db`

### Inspeccionar la Base de Datos

#### En Emulador Android:
```bash
# Acceder al shell del emulador
adb shell

# Navegar a la base de datos
cd /data/data/com.example.hospital_appointments/databases/

# Abrir SQLite
sqlite3 hospital_appointments.db

# Comandos útiles
.tables                 # Listar tablas
.schema patients        # Ver esquema
SELECT * FROM patients; # Consultar datos
.exit                   # Salir
```

## 🧪 Testing

```bash
# Ejecutar todos los tests
flutter test

# Ejecutar tests con cobertura
flutter test --coverage

# Ver reporte de cobertura
genhtml coverage/lcov.info -o coverage/html
```

## 📝 Estructura de Código

### Modelos y Entidades

- **Patient**: Representa un paciente con datos personales
- **Appointment**: Representa una cita médica vinculada a un paciente

### Providers (MVVM)

- **PatientProvider**: Gestiona el estado de pacientes
- **AppointmentProvider**: Gestiona el estado de citas

### Repositorios

- **PatientRepository**: Interfaz para operaciones CRUD de pacientes
- **AppointmentRepository**: Interfaz para operaciones CRUD de citas

### DataSources

- **PatientLocalDataSource**: Acceso directo a SQLite para pacientes
- **AppointmentLocalDataSource**: Acceso directo a SQLite para citas

## 🎨 Personalización

### Cambiar el Tema de Colores

Edita `lib/main.dart`:

```dart
ColorScheme.fromSeed(
  seedColor: Colors.blue, // Cambia este color
  brightness: Brightness.light,
)
```

### Cambiar el Nombre de la App

1. **Android**: Edita `android/app/src/main/AndroidManifest.xml`
```xml
<application
    android:label="Tu Nombre de App"
    ...>
```

2. **iOS**: Edita `ios/Runner/Info.plist`
```xml
<key>CFBundleDisplayName</key>
<string>Tu Nombre de App</string>
```

### Cambiar el Ícono de la App

Usa el paquete `flutter_launcher_icons`:

```bash
flutter pub add dev:flutter_launcher_icons
```

Crea `flutter_launcher_icons.yaml` y ejecuta:
```bash
dart run flutter_launcher_icons
```

## 🐛 Solución de Problemas

### Error: "No devices found"
```bash
# Verificar dispositivos conectados
flutter devices

# Si no aparecen, verificar conexión USB o iniciar emulador
```

### Error al instalar dependencias
```bash
# Limpiar caché de Flutter
flutter clean

# Reinstalar dependencias
flutter pub get
```

### Error de compilación en Android
```bash
# Limpiar build de Android
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### Error de compilación en iOS
```bash
# Limpiar pods
cd ios
pod deintegrate
pod install
cd ..
flutter clean
```

## 📄 Licencia

Este proyecto es de código abierto y está disponible bajo la licencia MIT.

## 👨‍💻 Autor

Desarrollado siguiendo las mejores prácticas de Flutter y Dart, con Clean Architecture y principios SOLID.

## 📚 Recursos Adicionales

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Documentation](https://dart.dev/guides)
- [Provider Package](https://pub.dev/packages/provider)
- [SQFlite Package](https://pub.dev/packages/sqflite)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

## 🆘 Soporte

Si encuentras algún problema o tienes preguntas:
1. Revisa la sección de solución de problemas
2. Verifica la documentación oficial de Flutter
3. Busca en Stack Overflow
4. Abre un issue en el repositorio

---

¡Desarrolla con excelencia! 🚀