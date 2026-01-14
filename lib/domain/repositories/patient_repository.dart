import 'package:hospital_appointments/domain/entities/patient.dart';

/// Interfaz del Repositorio de Pacientes
/// 
/// Define el contrato para las operaciones CRUD sobre pacientes.
/// Sigue el principio de Inversión de Dependencias (SOLID).
/// La capa de dominio define la interfaz, la capa de datos la implementa.
abstract class PatientRepository {
  /// Crea un nuevo paciente en la base de datos
  /// 
  /// Retorna el paciente creado con su ID asignado
  /// Lanza [DatabaseException] si hay un error en la base de datos
  /// Lanza [ValidationException] si los datos no son válidos
  Future<Patient> createPatient(Patient patient);

  /// Obtiene un paciente por su ID
  /// 
  /// Retorna el paciente si existe
  /// Lanza [NotFoundException] si no se encuentra el paciente
  Future<Patient> getPatientById(int id);

  /// Obtiene todos los pacientes
  /// 
  /// Retorna una lista de todos los pacientes, ordenados por nombre
  /// Retorna lista vacía si no hay pacientes
  Future<List<Patient>> getAllPatients();

  /// Actualiza los datos de un paciente existente
  /// 
  /// Retorna el paciente actualizado
  /// Lanza [NotFoundException] si no se encuentra el paciente
  /// Lanza [ValidationException] si los datos no son válidos
  Future<Patient> updatePatient(Patient patient);

  /// Elimina un paciente por su ID
  /// 
  /// Lanza [NotFoundException] si no se encuentra el paciente
  /// Lanza [DatabaseException] si hay citas asociadas al paciente
  Future<void> deletePatient(int id);

  /// Busca pacientes por nombre o apellido
  /// 
  /// Retorna una lista de pacientes que coincidan con el término de búsqueda
  /// La búsqueda es case-insensitive y busca coincidencias parciales
  Future<List<Patient>> searchPatients(String searchTerm);
}
