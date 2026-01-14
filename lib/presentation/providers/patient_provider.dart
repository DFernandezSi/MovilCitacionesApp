import 'package:flutter/foundation.dart';
import 'package:hospital_appointments/core/errors/exceptions.dart';
import 'package:hospital_appointments/domain/entities/patient.dart';
import 'package:hospital_appointments/domain/repositories/patient_repository.dart';

/// Provider para gestionar el estado de los pacientes
/// 
/// Implementa el patrón MVVM usando ChangeNotifier de Flutter.
/// Gestiona el estado de la UI relacionado con pacientes.
/// Sigue el principio de Single Responsibility.
class PatientProvider extends ChangeNotifier {
  final PatientRepository _repository;

  PatientProvider(this._repository);

  // Estado
  List<Patient> _patients = [];
  Patient? _selectedPatient;
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  // Getters
  List<Patient> get patients => _patients;
  Patient? get selectedPatient => _selectedPatient;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  /// Obtiene todos los pacientes
  Future<void> loadPatients() async {
    _setLoading(true);
    _clearError();

    try {
      _patients = await _repository.getAllPatients();
      notifyListeners();
    } catch (e) {
      _handleError('Error al cargar pacientes', e);
    } finally {
      _setLoading(false);
    }
  }

  /// Busca pacientes por nombre o apellido
  Future<void> searchPatients(String query) async {
    _searchQuery = query;
    _setLoading(true);
    _clearError();

    try {
      if (query.trim().isEmpty) {
        await loadPatients();
      } else {
        _patients = await _repository.searchPatients(query);
        notifyListeners();
      }
    } catch (e) {
      _handleError('Error al buscar pacientes', e);
    } finally {
      _setLoading(false);
    }
  }

  /// Crea un nuevo paciente
  Future<bool> createPatient(Patient patient) async {
    _setLoading(true);
    _clearError();

    try {
      final createdPatient = await _repository.createPatient(patient);
      _patients.add(createdPatient);
      _patients.sort((a, b) => a.firstName.compareTo(b.firstName));
      notifyListeners();
      return true;
    } catch (e) {
      _handleError('Error al crear paciente', e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Actualiza un paciente existente
  Future<bool> updatePatient(Patient patient) async {
    _setLoading(true);
    _clearError();

    try {
      final updatedPatient = await _repository.updatePatient(patient);
      final index = _patients.indexWhere((p) => p.id == updatedPatient.id);
      if (index != -1) {
        _patients[index] = updatedPatient;
        _patients.sort((a, b) => a.firstName.compareTo(b.firstName));
      }
      if (_selectedPatient?.id == updatedPatient.id) {
        _selectedPatient = updatedPatient;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _handleError('Error al actualizar paciente', e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Elimina un paciente
  Future<bool> deletePatient(int id) async {
    _setLoading(true);
    _clearError();

    try {
      await _repository.deletePatient(id);
      _patients.removeWhere((p) => p.id == id);
      if (_selectedPatient?.id == id) {
        _selectedPatient = null;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _handleError('Error al eliminar paciente', e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Selecciona un paciente para ver sus detalles
  Future<void> selectPatient(int id) async {
    _setLoading(true);
    _clearError();

    try {
      _selectedPatient = await _repository.getPatientById(id);
      notifyListeners();
    } catch (e) {
      _handleError('Error al cargar paciente', e);
    } finally {
      _setLoading(false);
    }
  }

  /// Limpia el paciente seleccionado
  void clearSelectedPatient() {
    _selectedPatient = null;
    notifyListeners();
  }

  /// Limpia el error
  void clearError() {
    _clearError();
    notifyListeners();
  }

  // Métodos privados auxiliares
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  void _handleError(String message, Object error) {
    if (error is ValidationException) {
      _errorMessage = error.message;
    } else if (error is NotFoundException) {
      _errorMessage = error.message;
    } else if (error is AppDatabaseException) {
      _errorMessage = error.message;
    } else {
      _errorMessage = '$message: $error';
    }
    notifyListeners();
  }
}
