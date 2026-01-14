import 'package:sqflite/sqflite.dart';
import 'package:hospital_appointments/core/constants/app_constants.dart';
import 'package:hospital_appointments/core/errors/exceptions.dart' as app_exceptions;
import 'package:hospital_appointments/data/datasources/database_helper.dart';
import 'package:hospital_appointments/data/models/appointment_model.dart';

/// DataSource local para operaciones CRUD de Citas
/// 
/// Implementa las operaciones de acceso a datos para citas médicas.
/// Se comunica directamente con SQLite a través del DatabaseHelper.
/// Sigue el principio de Single Responsibility.
class AppointmentLocalDataSource {
  final DatabaseHelper _databaseHelper;

  AppointmentLocalDataSource(this._databaseHelper);

  /// Inserta una nueva cita en la base de datos
  Future<AppointmentModel> insertAppointment(AppointmentModel appointment) async {
    try {
      final db = await _databaseHelper.database;
      final id = await db.insert(
        AppConstants.tableAppointmentsName,
        appointment.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
      return appointment.copyWith(id: id);
    } catch (e) {
      throw app_exceptions.AppDatabaseException('Error al crear la cita: $e');
    }
  }

  /// Obtiene una cita por su ID con los datos del paciente asociado
  Future<AppointmentModel> getAppointmentById(int id) async {
    try {
      final db = await _databaseHelper.database;
      final maps = await db.rawQuery('''
        SELECT 
          a.id, a.patient_id, a.appointment_date, a.notes, 
          a.created_at, a.updated_at,
          p.first_name, p.last_name, p.birth_date, p.phone, p.email,
          p.created_at as patient_created_at, p.updated_at as patient_updated_at
        FROM ${AppConstants.tableAppointmentsName} a
        INNER JOIN ${AppConstants.tablePatientsName} p ON a.patient_id = p.id
        WHERE a.id = ?
      ''', [id]);

      if (maps.isEmpty) {
        throw app_exceptions.NotFoundException('Cita con ID $id no encontrada');
      }

      return AppointmentModel.fromMap(maps.first);
    } catch (e) {
      if (e is app_exceptions.NotFoundException) rethrow;
      throw app_exceptions.AppDatabaseException('Error al obtener la cita: $e');
    }
  }

  /// Obtiene todas las citas con sus pacientes asociados
  Future<List<AppointmentModel>> getAllAppointments() async {
    try {
      final db = await _databaseHelper.database;
      final maps = await db.rawQuery('''
        SELECT 
          a.id, a.patient_id, a.appointment_date, a.notes, 
          a.created_at, a.updated_at,
          p.first_name, p.last_name, p.birth_date, p.phone, p.email,
          p.created_at as patient_created_at, p.updated_at as patient_updated_at
        FROM ${AppConstants.tableAppointmentsName} a
        INNER JOIN ${AppConstants.tablePatientsName} p ON a.patient_id = p.id
        ORDER BY a.appointment_date DESC
      ''');

      return maps.map((map) => AppointmentModel.fromMap(map)).toList();
    } catch (e) {
      throw app_exceptions.AppDatabaseException('Error al obtener las citas: $e');
    }
  }

  /// Obtiene las citas de un paciente específico
  Future<List<AppointmentModel>> getAppointmentsByPatientId(int patientId) async {
    try {
      final db = await _databaseHelper.database;
      final maps = await db.rawQuery('''
        SELECT 
          a.id, a.patient_id, a.appointment_date, a.notes, 
          a.created_at, a.updated_at,
          p.first_name, p.last_name, p.birth_date, p.phone, p.email,
          p.created_at as patient_created_at, p.updated_at as patient_updated_at
        FROM ${AppConstants.tableAppointmentsName} a
        INNER JOIN ${AppConstants.tablePatientsName} p ON a.patient_id = p.id
        WHERE a.patient_id = ?
        ORDER BY a.appointment_date DESC
      ''', [patientId]);

      return maps.map((map) => AppointmentModel.fromMap(map)).toList();
    } catch (e) {
      throw app_exceptions.AppDatabaseException('Error al obtener las citas del paciente: $e');
    }
  }

  /// Obtiene las citas de un día específico
  Future<List<AppointmentModel>> getAppointmentsByDay(DateTime day) async {
    try {
      final db = await _databaseHelper.database;
      final startOfDay = DateTime(day.year, day.month, day.day);
      final endOfDay = DateTime(day.year, day.month, day.day, 23, 59, 59);

      final maps = await db.rawQuery('''
        SELECT 
          a.id, a.patient_id, a.appointment_date, a.notes, 
          a.created_at, a.updated_at,
          p.first_name, p.last_name, p.birth_date, p.phone, p.email,
          p.created_at as patient_created_at, p.updated_at as patient_updated_at
        FROM ${AppConstants.tableAppointmentsName} a
        INNER JOIN ${AppConstants.tablePatientsName} p ON a.patient_id = p.id
        WHERE a.appointment_date >= ? AND a.appointment_date <= ?
        ORDER BY a.appointment_date ASC
      ''', [startOfDay.toIso8601String(), endOfDay.toIso8601String()]);

      return maps.map((map) => AppointmentModel.fromMap(map)).toList();
    } catch (e) {
      throw app_exceptions.AppDatabaseException('Error al obtener las citas del día: $e');
    }
  }

  /// Obtiene las citas de un mes específico
  Future<List<AppointmentModel>> getAppointmentsByMonth(int year, int month) async {
    try {
      final db = await _databaseHelper.database;
      final startOfMonth = DateTime(year, month, 1);
      final endOfMonth = DateTime(year, month + 1, 0, 23, 59, 59);

      final maps = await db.rawQuery('''
        SELECT 
          a.id, a.patient_id, a.appointment_date, a.notes, 
          a.created_at, a.updated_at,
          p.first_name, p.last_name, p.birth_date, p.phone, p.email,
          p.created_at as patient_created_at, p.updated_at as patient_updated_at
        FROM ${AppConstants.tableAppointmentsName} a
        INNER JOIN ${AppConstants.tablePatientsName} p ON a.patient_id = p.id
        WHERE a.appointment_date >= ? AND a.appointment_date <= ?
        ORDER BY a.appointment_date ASC
      ''', [startOfMonth.toIso8601String(), endOfMonth.toIso8601String()]);

      return maps.map((map) => AppointmentModel.fromMap(map)).toList();
    } catch (e) {
      throw app_exceptions.AppDatabaseException('Error al obtener las citas del mes: $e');
    }
  }

  /// Actualiza una cita existente
  Future<AppointmentModel> updateAppointment(AppointmentModel appointment) async {
    try {
      final db = await _databaseHelper.database;
      final count = await db.update(
        AppConstants.tableAppointmentsName,
        appointment.toMap(),
        where: 'id = ?',
        whereArgs: [appointment.id],
      );

      if (count == 0) {
        throw app_exceptions.NotFoundException('Cita con ID ${appointment.id} no encontrada');
      }

      // Obtener la cita actualizada con los datos del paciente
      return await getAppointmentById(appointment.id!);
    } catch (e) {
      if (e is app_exceptions.NotFoundException) rethrow;
      throw app_exceptions.AppDatabaseException('Error al actualizar la cita: $e');
    }
  }

  /// Elimina una cita por su ID
  Future<void> deleteAppointment(int id) async {
    try {
      final db = await _databaseHelper.database;
      final count = await db.delete(
        AppConstants.tableAppointmentsName,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (count == 0) {
        throw app_exceptions.NotFoundException('Cita con ID $id no encontrada');
      }
    } catch (e) {
      if (e is app_exceptions.NotFoundException) rethrow;
      throw app_exceptions.AppDatabaseException('Error al eliminar la cita: $e');
    }
  }
}
