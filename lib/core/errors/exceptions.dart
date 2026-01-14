/// Excepciones personalizadas de la aplicación
/// 
/// Define las excepciones que pueden ocurrir en la capa de datos y dominio,
/// siguiendo el principio de separación de responsabilidades.

/// Excepción base para errores de base de datos
class AppDatabaseException implements Exception {
  final String message;
  
  AppDatabaseException(this.message);
  
  @override
  String toString() => 'AppDatabaseException: $message';
}

/// Excepción cuando no se encuentra un registro
class NotFoundException implements Exception {
  final String message;
  
  NotFoundException(this.message);
  
  @override
  String toString() => 'NotFoundException: $message';
}

/// Excepción de validación de datos
class ValidationException implements Exception {
  final String message;
  
  ValidationException(this.message);
  
  @override
  String toString() => 'ValidationException: $message';
}

/// Excepción cuando ya existe un registro duplicado
class DuplicateException implements Exception {
  final String message;
  
  DuplicateException(this.message);
  
  @override
  String toString() => 'DuplicateException: $message';
}
