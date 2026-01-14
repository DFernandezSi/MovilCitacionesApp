import 'package:hospital_appointments/domain/entities/appointment.dart';

/// Interfaz del Repositorio de Citas
/// 
/// Define el contrato para las operaciones CRUD sobre citas médicas.
/// Sigue el principio de Inversión de Dependencias (SOLID).
/// La capa de dominio define la interfaz, la capa de datos la implementa.
abstract class AppointmentRepository {
  /// Crea una nueva cita en la base de datos
  /// 
  /// Retorna la cita creada con su ID asignado
  /// Lanza [DatabaseException] si hay un error en la base de datos
  /// Lanza [ValidationException] si los datos no son válidos
  Future<Appointment> createAppointment(Appointment appointment);

  /// Obtiene una cita por su ID
  /// 
  /// Retorna la cita con los datos del paciente asociado
  /// Lanza [NotFoundException] si no se encuentra la cita
  Future<Appointment> getAppointmentById(int id);

  /// Obtiene todas las citas
  /// 
  /// Retorna una lista de todas las citas con sus pacientes asociados
  /// Las citas están ordenadas por fecha descendente
  Future<List<Appointment>> getAllAppointments();

  /// Obtiene las citas de un paciente específico
  /// 
  /// Retorna una lista de citas del paciente, ordenadas por fecha
  Future<List<Appointment>> getAppointmentsByPatientId(int patientId);

  /// Obtiene las citas de un día específico
  /// 
  /// Retorna una lista de citas para la fecha dada
  /// Incluye todas las citas desde las 00:00 hasta las 23:59 del día
  Future<List<Appointment>> getAppointmentsByDay(DateTime day);

  /// Obtiene las citas de un mes específico
  /// 
  /// Retorna una lista de citas para el mes y año dados
  /// Incluye todas las citas desde el día 1 hasta el último día del mes
  Future<List<Appointment>> getAppointmentsByMonth(int year, int month);

  /// Actualiza los datos de una cita existente
  /// 
  /// Retorna la cita actualizada
  /// Lanza [NotFoundException] si no se encuentra la cita
  /// Lanza [ValidationException] si los datos no son válidos
  Future<Appointment> updateAppointment(Appointment appointment);

  /// Elimina una cita por su ID
  /// 
  /// Lanza [NotFoundException] si no se encuentra la cita
  Future<void> deleteAppointment(int id);
}
