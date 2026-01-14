import 'package:hospital_appointments/core/errors/exceptions.dart';
import 'package:hospital_appointments/data/datasources/appointment_local_datasource.dart';
import 'package:hospital_appointments/data/models/appointment_model.dart';
import 'package:hospital_appointments/domain/entities/appointment.dart';
import 'package:hospital_appointments/domain/repositories/appointment_repository.dart';

/// Implementación del Repositorio de Citas
/// 
/// Implementa la interfaz AppointmentRepository definida en la capa de dominio.
/// Actúa como intermediario entre la capa de datos y la capa de dominio.
/// Sigue el principio de Inversión de Dependencias (SOLID).
class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentLocalDataSource _localDataSource;

  AppointmentRepositoryImpl(this._localDataSource);

  @override
  Future<Appointment> createAppointment(Appointment appointment) async {
    try {
      // Validar que la cita sea válida antes de guardarla
      _validateAppointment(appointment);

      // Agregar timestamps
      final now = DateTime.now();
      final appointmentModel = AppointmentModel.fromEntity(
        appointment.copyWith(
          createdAt: now,
          updatedAt: now,
        ),
      );

      final createdAppointment = await _localDataSource.insertAppointment(appointmentModel);
      return createdAppointment.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Appointment> getAppointmentById(int id) async {
    try {
      final appointmentModel = await _localDataSource.getAppointmentById(id);
      return appointmentModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Appointment>> getAllAppointments() async {
    try {
      final appointmentModels = await _localDataSource.getAllAppointments();
      return appointmentModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Appointment>> getAppointmentsByPatientId(int patientId) async {
    try {
      final appointmentModels = await _localDataSource.getAppointmentsByPatientId(patientId);
      return appointmentModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Appointment>> getAppointmentsByDay(DateTime day) async {
    try {
      final appointmentModels = await _localDataSource.getAppointmentsByDay(day);
      return appointmentModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Appointment>> getAppointmentsByMonth(int year, int month) async {
    try {
      final appointmentModels = await _localDataSource.getAppointmentsByMonth(year, month);
      return appointmentModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Appointment> updateAppointment(Appointment appointment) async {
    try {
      if (appointment.id == null) {
        throw ValidationException('ID de la cita es requerido para actualizar');
      }

      // Validar que la cita sea válida antes de actualizarla
      _validateAppointment(appointment);

      // Actualizar timestamp de modificación
      final appointmentModel = AppointmentModel.fromEntity(
        appointment.copyWith(
          updatedAt: DateTime.now(),
        ),
      );

      final updatedAppointment = await _localDataSource.updateAppointment(appointmentModel);
      return updatedAppointment.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteAppointment(int id) async {
    try {
      await _localDataSource.deleteAppointment(id);
    } catch (e) {
      rethrow;
    }
  }

  /// Valida que los datos de la cita sean correctos
  void _validateAppointment(Appointment appointment) {
    if (appointment.patientId <= 0) {
      throw ValidationException('ID del paciente es requerido');
    }
  }
}
