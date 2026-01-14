import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:hospital_appointments/core/constants/app_constants.dart';

/// Helper para gestionar la base de datos SQLite
/// 
/// Implementa el patrón Singleton para garantizar una única instancia de la BD.
/// Se encarga de la creación, migración y obtención de la base de datos.
/// Sigue el principio de Single Responsibility.
class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  // Constructor privado para el patrón Singleton
  DatabaseHelper._();

  /// Obtiene la instancia única del DatabaseHelper
  static DatabaseHelper get instance {
    _instance ??= DatabaseHelper._();
    return _instance!;
  }

  /// Obtiene la base de datos, creándola si no existe
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Inicializa la base de datos
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.databaseName);

    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Crea las tablas de la base de datos
  Future<void> _onCreate(Database db, int version) async {
    // Tabla de pacientes
    await db.execute('''
      CREATE TABLE ${AppConstants.tablePatientsName} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        first_name TEXT NOT NULL,
        last_name TEXT NOT NULL,
        birth_date TEXT NOT NULL,
        phone TEXT NOT NULL,
        email TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Tabla de citas
    await db.execute('''
      CREATE TABLE ${AppConstants.tableAppointmentsName} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        patient_id INTEGER NOT NULL,
        appointment_date TEXT NOT NULL,
        notes TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (patient_id) REFERENCES ${AppConstants.tablePatientsName} (id) ON DELETE CASCADE
      )
    ''');

    // Índices para mejorar el rendimiento de las consultas
    await db.execute('''
      CREATE INDEX idx_appointments_patient_id 
      ON ${AppConstants.tableAppointmentsName} (patient_id)
    ''');

    await db.execute('''
      CREATE INDEX idx_appointments_date 
      ON ${AppConstants.tableAppointmentsName} (appointment_date)
    ''');

    await db.execute('''
      CREATE INDEX idx_patients_name 
      ON ${AppConstants.tablePatientsName} (first_name, last_name)
    ''');
  }

  /// Maneja las migraciones de la base de datos
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Aquí se pueden agregar migraciones futuras
    // Por ejemplo:
    // if (oldVersion < 2) {
    //   await db.execute('ALTER TABLE patients ADD COLUMN new_field TEXT');
    // }
  }

  /// Cierra la base de datos
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  /// Elimina la base de datos (útil para testing)
  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}
