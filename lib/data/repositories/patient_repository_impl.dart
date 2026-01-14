import 'package:hospital_appointments/core/errors/exceptions.dart';
import 'package:hospital_appointments/data/datasources/patient_local_datasource.dart';
import 'package:hospital_appointments/data/models/patient_model.dart';
import 'package:hospital_appointments/domain/entities/patient.dart';
import 'package:hospital_appointments/domain/repositories/patient_repository.dart';

/// Implementación del Repositorio de Pacientes
/// 
/// Implementa la interfaz PatientRepository definida en la capa de dominio.
/// Actúa como intermediario entre la capa de datos y la capa de dominio.
/// Sigue el principio de Inversión de Dependencias (SOLID).
class PatientRepositoryImpl implements PatientRepository {
  final PatientLocalDataSource _localDataSource;

  PatientRepositoryImpl(this._localDataSource);

  @override
  Future<Patient> createPatient(Patient patient) async {
    try {
      // Validar que el paciente sea válido antes de guardarlo
      _validatePatient(patient);

      // Agregar timestamps
      final now = DateTime.now();
      final patientModel = PatientModel.fromEntity(
        patient.copyWith(
          createdAt: now,
          updatedAt: now,
        ),
      );

      final createdPatient = await _localDataSource.insertPatient(patientModel);
      return createdPatient.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Patient> getPatientById(int id) async {
    try {
      final patientModel = await _localDataSource.getPatientById(id);
      return patientModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Patient>> getAllPatients() async {
    try {
      final patientModels = await _localDataSource.getAllPatients();
      return patientModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Patient> updatePatient(Patient patient) async {
    try {
      if (patient.id == null) {
        throw ValidationException('ID del paciente es requerido para actualizar');
      }

      // Validar que el paciente sea válido antes de actualizarlo
      _validatePatient(patient);

      // Actualizar timestamp de modificación
      final patientModel = PatientModel.fromEntity(
        patient.copyWith(
          updatedAt: DateTime.now(),
        ),
      );

      final updatedPatient = await _localDataSource.updatePatient(patientModel);
      return updatedPatient.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deletePatient(int id) async {
    try {
      await _localDataSource.deletePatient(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Patient>> searchPatients(String searchTerm) async {
    try {
      if (searchTerm.trim().isEmpty) {
        return await getAllPatients();
      }
      
      final patientModels = await _localDataSource.searchPatients(searchTerm);
      return patientModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Valida que los datos del paciente sean correctos
  void _validatePatient(Patient patient) {
    if (patient.firstName.trim().isEmpty) {
      throw ValidationException('Nombre es requerido');
    }
    if (patient.lastName.trim().isEmpty) {
      throw ValidationException('Apellidos son requeridos');
    }
    if (patient.phone.trim().isEmpty) {
      throw ValidationException('Teléfono es requerido');
    }
    if (patient.email.trim().isEmpty) {
      throw ValidationException('Email es requerido');
    }
    if (patient.birthDate.isAfter(DateTime.now())) {
      throw ValidationException('Fecha de nacimiento no puede ser futura');
    }
  }
}
