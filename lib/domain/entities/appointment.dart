import 'package:equatable/equatable.dart';
import 'package:hospital_appointments/domain/entities/patient.dart';

/// Entidad de dominio para una Cita Médica
/// 
/// Representa una cita médica asociada a un paciente.
/// Usa Equatable para comparación de igualdad basada en valores.
/// Sigue el principio de inmutabilidad para mantener la integridad de los datos.
class Appointment extends Equatable {
  final int? id;
  final int patientId;
  final DateTime appointmentDate;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Datos del paciente asociado (cargados mediante join)
  final Patient? patient;

  const Appointment({
    this.id,
    required this.patientId,
    required this.appointmentDate,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.patient,
  });

  /// Verifica si la cita está en el pasado
  bool get isPast {
    return appointmentDate.isBefore(DateTime.now());
  }

  /// Verifica si la cita es hoy
  bool get isToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final appointmentDay = DateTime(
      appointmentDate.year,
      appointmentDate.month,
      appointmentDate.day,
    );
    return today == appointmentDay;
  }

  /// Verifica si la cita es futura
  bool get isFuture {
    return appointmentDate.isAfter(DateTime.now());
  }

  /// Crea una copia de la cita con algunos campos modificados
  Appointment copyWith({
    int? id,
    int? patientId,
    DateTime? appointmentDate,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    Patient? patient,
  }) {
    return Appointment(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      patient: patient ?? this.patient,
    );
  }

  @override
  List<Object?> get props => [
        id,
        patientId,
        appointmentDate,
        notes,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'Appointment{id: $id, patientId: $patientId, date: $appointmentDate, patient: ${patient?.fullName ?? "N/A"}}';
  }
}
