import 'package:hospital_appointments/core/constants/app_constants.dart';
import 'package:hospital_appointments/core/errors/exceptions.dart';

/// Utilidades para validación de datos
/// 
/// Proporciona métodos estáticos para validar campos de formularios
/// y datos de entrada, siguiendo el principio de Single Responsibility.
class ValidationUtils {
  /// Valida que un nombre no esté vacío y tenga longitud adecuada
  static String? validateName(String? value, {String fieldName = 'Nombre'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es requerido';
    }
    
    if (value.trim().length < AppConstants.minNameLength) {
      return '$fieldName debe tener al menos ${AppConstants.minNameLength} caracteres';
    }
    
    if (value.trim().length > AppConstants.maxNameLength) {
      return '$fieldName no puede exceder ${AppConstants.maxNameLength} caracteres';
    }
    
    return null;
  }
  
  /// Valida que un email tenga formato válido
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email es requerido';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Email no válido';
    }
    
    return null;
  }
  
  /// Valida que un teléfono tenga formato válido (10 dígitos)
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Teléfono es requerido';
    }
    
    final phoneRegex = RegExp(r'^\d{10}$');
    
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Teléfono debe tener 10 dígitos';
    }
    
    return null;
  }
  
  /// Valida que una fecha no esté vacía
  static String? validateDate(DateTime? value, {String fieldName = 'Fecha'}) {
    if (value == null) {
      return '$fieldName es requerida';
    }
    
    return null;
  }
  
  /// Valida que una fecha de nacimiento sea válida (no futura, edad razonable)
  static String? validateBirthDate(DateTime? value) {
    if (value == null) {
      return 'Fecha de nacimiento es requerida';
    }
    
    final now = DateTime.now();
    if (value.isAfter(now)) {
      return 'Fecha de nacimiento no puede ser futura';
    }
    
    final age = now.year - value.year;
    if (age > 150) {
      return 'Fecha de nacimiento no válida';
    }
    
    return null;
  }
  
  /// Valida que una fecha de cita sea válida (no pasada)
  static String? validateAppointmentDate(DateTime? value) {
    if (value == null) {
      return 'Fecha de cita es requerida';
    }
    
    final now = DateTime.now();
    if (value.isBefore(now.subtract(const Duration(hours: 1)))) {
      return 'La fecha de la cita no puede ser en el pasado';
    }
    
    return null;
  }
}
