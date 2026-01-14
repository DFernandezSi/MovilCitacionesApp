/// Constantes globales de la aplicación
/// 
/// Contiene las constantes utilizadas en toda la aplicación,
/// incluyendo nombres de base de datos, tablas y configuraciones.
class AppConstants {
  // Database
  static const String databaseName = 'hospital_appointments.db';
  static const int databaseVersion = 1;
  
  // Tables
  static const String tablePatientsName = 'patients';
  static const String tableAppointmentsName = 'appointments';
  
  // Date formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  
  // Validation
  static const int minNameLength = 2;
  static const int maxNameLength = 100;
  static const int phoneLength = 10;
}
