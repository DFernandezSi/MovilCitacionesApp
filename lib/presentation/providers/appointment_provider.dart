import 'package:flutter/foundation.dart';
import 'package:hospital_appointments/core/errors/exceptions.dart';
import 'package:hospital_appointments/domain/entities/appointment.dart';
import 'package:hospital_appointments/domain/repositories/appointment_repository.dart';

/// Provider para gestionar el estado de las citas
/// 
/// Implementa el patrón MVVM usando ChangeNotifier de Flutter.
/// Gestiona el estado de la UI relacionado con citas médicas.
/// Sigue el principio de Single Responsibility.
class AppointmentProvider extends ChangeNotifier {
  final AppointmentRepository _repository;

  AppointmentProvider(this._repository);

  // Estado
  List<Appointment> _appointments = [];
  Appointment? _selectedAppointment;
  bool _isLoading = false;
  String? _errorMessage;
  DateTime? _selectedDate;
  int? _selectedMonth;
  int? _selectedYear;

  // Getters
  List<Appointment> get appointments => _appointments;
  Appointment? get selectedAppointment => _selectedAppointment;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DateTime? get selectedDate => _selectedDate;
  int? get selectedMonth => _selectedMonth;
  int? get selectedYear => _selectedYear;

  /// Obtiene todas las citas
  Future<void> loadAppointments() async {
    _setLoading(true);
    _clearError();
    _selectedDate = null;
    _selectedMonth = null;
    _selectedYear = null;

    try {
      _appointments = await _repository.getAllAppointments();
      notifyListeners();
    } catch (e) {
      _handleError('Error al cargar citas', e);
    } finally {
      _setLoading(false);
    }
  }

  /// Obtiene las citas de un paciente específico
  Future<void> loadAppointmentsByPatient(int patientId) async {
    _setLoading(true);
    _clearError();

    try {
      _appointments = await _repository.getAppointmentsByPatientId(patientId);
      notifyListeners();
    } catch (e) {
      _handleError('Error al cargar citas del paciente', e);
    } finally {
      _setLoading(false);
    }
  }

  /// Obtiene las citas de un día específico
  Future<void> loadAppointmentsByDay(DateTime day) async {
    _setLoading(true);
    _clearError();
    _selectedDate = day;
    _selectedMonth = null;
    _selectedYear = null;

    try {
      _appointments = await _repository.getAppointmentsByDay(day);
      notifyListeners();
    } catch (e) {
      _handleError('Error al cargar citas del día', e);
    } finally {
      _setLoading(false);
    }
  }

  /// Obtiene las citas de un mes específico
  Future<void> loadAppointmentsByMonth(int year, int month) async {
    _setLoading(true);
    _clearError();
    _selectedDate = null;
    _selectedMonth = month;
    _selectedYear = year;

    try {
      _appointments = await _repository.getAppointmentsByMonth(year, month);
      notifyListeners();
    } catch (e) {
      _handleError('Error al cargar citas del mes', e);
    } finally {
      _setLoading(false);
    }
  }

  /// Crea una nueva cita
  Future<bool> createAppointment(Appointment appointment) async {
    _setLoading(true);
    _clearError();

    try {
      final createdAppointment = await _repository.createAppointment(appointment);
      _appointments.insert(0, createdAppointment);
      notifyListeners();
      return true;
    } catch (e) {
      _handleError('Error al crear cita', e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Actualiza una cita existente
  Future<bool> updateAppointment(Appointment appointment) async {
    _setLoading(true);
    _clearError();

    try {
      final updatedAppointment = await _repository.updateAppointment(appointment);
      final index = _appointments.indexWhere((a) => a.id == updatedAppointment.id);
      if (index != -1) {
        _appointments[index] = updatedAppointment;
      }
      if (_selectedAppointment?.id == updatedAppointment.id) {
        _selectedAppointment = updatedAppointment;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _handleError('Error al actualizar cita', e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Elimina una cita
  Future<bool> deleteAppointment(int id) async {
    _setLoading(true);
    _clearError();

    try {
      await _repository.deleteAppointment(id);
      _appointments.removeWhere((a) => a.id == id);
      if (_selectedAppointment?.id == id) {
        _selectedAppointment = null;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _handleError('Error al eliminar cita', e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Selecciona una cita para ver sus detalles
  Future<void> selectAppointment(int id) async {
    _setLoading(true);
    _clearError();

    try {
      _selectedAppointment = await _repository.getAppointmentById(id);
      notifyListeners();
    } catch (e) {
      _handleError('Error al cargar cita', e);
    } finally {
      _setLoading(false);
    }
  }

  /// Limpia la cita seleccionada
  void clearSelectedAppointment() {
    _selectedAppointment = null;
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
