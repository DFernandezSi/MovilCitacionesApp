import 'package:sqflite/sqflite.dart';
import 'package:hospital_appointments/core/constants/app_constants.dart';
import 'package:hospital_appointments/core/errors/exceptions.dart' as app_exceptions;
import 'package:hospital_appointments/data/datasources/database_helper.dart';
import 'package:hospital_appointments/data/models/patient_model.dart';

/// DataSource local para operaciones CRUD de Pacientes
/// 
/// Implementa las operaciones de acceso a datos para pacientes.
/// Se comunica directamente con SQLite a través del DatabaseHelper.
/// Sigue el principio de Single Responsibility.
class PatientLocalDataSource {
  final DatabaseHelper _databaseHelper;

  PatientLocalDataSource(this._databaseHelper);

  /// Inserta un nuevo paciente en la base de datos
  Future<PatientModel> insertPatient(PatientModel patient) async {
    try {
      final db = await _databaseHelper.database;
      final id = await db.insert(
        AppConstants.tablePatientsName,
        patient.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
      return patient.copyWith(id: id);
    } catch (e) {
      throw app_exceptions.AppDatabaseException('Error al crear el paciente: $e');
    }
  }

  /// Obtiene un paciente por su ID
  Future<PatientModel> getPatientById(int id) async {
    try {
      final db = await _databaseHelper.database;
      final maps = await db.query(
        AppConstants.tablePatientsName,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isEmpty) {
        throw app_exceptions.NotFoundException('Paciente con ID $id no encontrado');
      }

      return PatientModel.fromMap(maps.first);
    } catch (e) {
      if (e is app_exceptions.NotFoundException) rethrow;
      throw app_exceptions.AppDatabaseException('Error al obtener el paciente: $e');
    }
  }

  /// Obtiene todos los pacientes ordenados por nombre
  Future<List<PatientModel>> getAllPatients() async {
    try {
      final db = await _databaseHelper.database;
      final maps = await db.query(
        AppConstants.tablePatientsName,
        orderBy: 'first_name ASC, last_name ASC',
      );

      return maps.map((map) => PatientModel.fromMap(map)).toList();
    } catch (e) {
      throw app_exceptions.AppDatabaseException('Error al obtener los pacientes: $e');
    }
  }

  /// Actualiza un paciente existente
  Future<PatientModel> updatePatient(PatientModel patient) async {
    try {
      final db = await _databaseHelper.database;
      final count = await db.update(
        AppConstants.tablePatientsName,
        patient.toMap(),
        where: 'id = ?',
        whereArgs: [patient.id],
      );

      if (count == 0) {
        throw app_exceptions.NotFoundException('Paciente con ID ${patient.id} no encontrado');
      }

      return patient;
    } catch (e) {
      if (e is app_exceptions.NotFoundException) rethrow;
      throw app_exceptions.AppDatabaseException('Error al actualizar el paciente: $e');
    }
  }

  /// Elimina un paciente por su ID
  Future<void> deletePatient(int id) async {
    try {
      final db = await _databaseHelper.database;
      
      // Verificar si tiene citas asociadas
      final appointments = await db.query(
        AppConstants.tableAppointmentsName,
        where: 'patient_id = ?',
        whereArgs: [id],
      );

      if (appointments.isNotEmpty) {
        throw app_exceptions.AppDatabaseException(
          'No se puede eliminar el paciente porque tiene ${appointments.length} cita(s) asociada(s)',
        );
      }

      final count = await db.delete(
        AppConstants.tablePatientsName,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (count == 0) {
        throw app_exceptions.NotFoundException('Paciente con ID $id no encontrado');
      }
    } catch (e) {
      if (e is app_exceptions.NotFoundException || e is app_exceptions.AppDatabaseException) rethrow;
      throw app_exceptions.AppDatabaseException('Error al eliminar el paciente: $e');
    }
  }

  /// Busca pacientes por nombre o apellido
  Future<List<PatientModel>> searchPatients(String searchTerm) async {
    try {
      final db = await _databaseHelper.database;
      final maps = await db.query(
        AppConstants.tablePatientsName,
        where: 'LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ?',
        whereArgs: ['%${searchTerm.toLowerCase()}%', '%${searchTerm.toLowerCase()}%'],
        orderBy: 'first_name ASC, last_name ASC',
      );

      return maps.map((map) => PatientModel.fromMap(map)).toList();
    } catch (e) {
      throw app_exceptions.AppDatabaseException('Error al buscar pacientes: $e');
    }
  }
}
