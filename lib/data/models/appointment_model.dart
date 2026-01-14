import 'package:hospital_appointments/domain/entities/appointment.dart';
import 'package:hospital_appointments/domain/entities/patient.dart';
import 'package:hospital_appointments/data/models/patient_model.dart';

/// Modelo de datos para Cita Médica
/// 
/// Representa la estructura de datos de la cita en la capa de datos.
/// Se encarga de la serialización/deserialización con la base de datos.
/// Sigue el patrón de separación entre entidad de dominio y modelo de datos.
class AppointmentModel extends Appointment {
  const AppointmentModel({
    super.id,
    required super.patientId,
    required super.appointmentDate,
    super.notes,
    required super.createdAt,
    required super.updatedAt,
    super.patient,
  });

  /// Crea un AppointmentModel desde un mapa (resultado de la base de datos)
  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    // Si el mapa incluye datos del paciente (join), los parsea también
    Patient? patient;
    if (map.containsKey('patient_id') && map['first_name'] != null) {
      patient = PatientModel.fromMap({
        'id': map['patient_id'],
        'first_name': map['first_name'],
        'last_name': map['last_name'],
        'birth_date': map['birth_date'],
        'phone': map['phone'],
        'email': map['email'],
        'created_at': map['patient_created_at'],
        'updated_at': map['patient_updated_at'],
      });
    }

    return AppointmentModel(
      id: map['id'] as int?,
      patientId: map['patient_id'] as int,
      appointmentDate: DateTime.parse(map['appointment_date'] as String),
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      patient: patient,
    );
  }

  /// Convierte el AppointmentModel a un mapa (para insertar en la base de datos)
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'patient_id': patientId,
      'appointment_date': appointmentDate.toIso8601String(),
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Crea un AppointmentModel desde una entidad Appointment
  factory AppointmentModel.fromEntity(Appointment appointment) {
    return AppointmentModel(
      id: appointment.id,
      patientId: appointment.patientId,
      appointmentDate: appointment.appointmentDate,
      notes: appointment.notes,
      createdAt: appointment.createdAt,
      updatedAt: appointment.updatedAt,
      patient: appointment.patient,
    );
  }

  /// Convierte el AppointmentModel a una entidad Appointment
  Appointment toEntity() {
    return Appointment(
      id: id,
      patientId: patientId,
      appointmentDate: appointmentDate,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
      patient: patient,
    );
  }

  @override
  AppointmentModel copyWith({
    int? id,
    int? patientId,
    DateTime? appointmentDate,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    Patient? patient,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      patient: patient ?? this.patient,
    );
  }
}
