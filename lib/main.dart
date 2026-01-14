import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hospital_appointments/data/datasources/database_helper.dart';
import 'package:hospital_appointments/data/datasources/patient_local_datasource.dart';
import 'package:hospital_appointments/data/datasources/appointment_local_datasource.dart';
import 'package:hospital_appointments/data/repositories/patient_repository_impl.dart';
import 'package:hospital_appointments/data/repositories/appointment_repository_impl.dart';
import 'package:hospital_appointments/presentation/providers/patient_provider.dart';
import 'package:hospital_appointments/presentation/providers/appointment_provider.dart';
import 'package:hospital_appointments/presentation/screens/home_screen.dart';

/// Punto de entrada de la aplicación
/// 
/// Configura la inyección de dependencias y el árbol de providers.
/// Sigue el patrón de Inversión de Dependencias (SOLID).
void main() {
  // Asegurar que Flutter esté inicializado
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

/// Widget raíz de la aplicación
/// 
/// Configura el tema, providers y la navegación inicial.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Configurar la inyección de dependencias
    final databaseHelper = DatabaseHelper.instance;
    final patientDataSource = PatientLocalDataSource(databaseHelper);
    final appointmentDataSource = AppointmentLocalDataSource(databaseHelper);
    final patientRepository = PatientRepositoryImpl(patientDataSource);
    final appointmentRepository = AppointmentRepositoryImpl(appointmentDataSource);

    return MultiProvider(
      providers: [
        // Provider para gestión de pacientes
        ChangeNotifierProvider(
          create: (_) => PatientProvider(patientRepository),
        ),
        // Provider para gestión de citas
        ChangeNotifierProvider(
          create: (_) => AppointmentProvider(appointmentRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Hospital Appointments',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Usar Material Design 3
          useMaterial3: true,
          // Esquema de colores basado en azul
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          // Configuración de la AppBar
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
          // Configuración de las tarjetas
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          // Configuración de los inputs
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          // Configuración de los botones
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        // Tema oscuro
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        // Modo de tema (automático según el sistema)
        themeMode: ThemeMode.system,
        // Pantalla inicial
        home: const HomeScreen(),
      ),
    );
  }
}
