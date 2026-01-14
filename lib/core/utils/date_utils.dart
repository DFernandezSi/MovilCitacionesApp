import 'package:intl/intl.dart';
import 'package:hospital_appointments/core/constants/app_constants.dart';

/// Utilidades para formateo de fechas
/// 
/// Proporciona métodos estáticos para convertir entre DateTime y String
/// siguiendo los formatos definidos en las constantes de la aplicación.
class DateUtils {
  /// Formatea un DateTime a String en formato de fecha
  static String formatDate(DateTime date) {
    return DateFormat(AppConstants.dateFormat).format(date);
  }
  
  /// Formatea un DateTime a String en formato de hora
  static String formatTime(DateTime date) {
    return DateFormat(AppConstants.timeFormat).format(date);
  }
  
  /// Formatea un DateTime a String en formato de fecha y hora
  static String formatDateTime(DateTime date) {
    return DateFormat(AppConstants.dateTimeFormat).format(date);
  }
  
  /// Parsea un String en formato de fecha a DateTime
  static DateTime parseDate(String dateString) {
    return DateFormat(AppConstants.dateFormat).parse(dateString);
  }
  
  /// Parsea un String en formato de fecha y hora a DateTime
  static DateTime parseDateTime(String dateTimeString) {
    return DateFormat(AppConstants.dateTimeFormat).parse(dateTimeString);
  }
  
  /// Obtiene el inicio del día para una fecha dada
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
  
  /// Obtiene el fin del día para una fecha dada
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }
  
  /// Obtiene el inicio del mes para una fecha dada
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }
  
  /// Obtiene el fin del mes para una fecha dada
  static DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0, 23, 59, 59);
  }
}
