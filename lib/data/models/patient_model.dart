import 'package:hospital_appointments/domain/entities/patient.dart';

/// Modelo de datos para Paciente
/// 
/// Representa la estructura de datos del paciente en la capa de datos.
/// Se encarga de la serialización/deserialización con la base de datos.
/// Sigue el patrón de separación entre entidad de dominio y modelo de datos.
class PatientModel extends Patient {
  const PatientModel({
    super.id,
    required super.firstName,
    required super.lastName,
    required super.birthDate,
    required super.phone,
    required super.email,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Crea un PatientModel desde un mapa (resultado de la base de datos)
  factory PatientModel.fromMap(Map<String, dynamic> map) {
    return PatientModel(
      id: map['id'] as int?,
      firstName: map['first_name'] as String,
      lastName: map['last_name'] as String,
      birthDate: DateTime.parse(map['birth_date'] as String),
      phone: map['phone'] as String,
      email: map['email'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  /// Convierte el PatientModel a un mapa (para insertar en la base de datos)
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'birth_date': birthDate.toIso8601String(),
      'phone': phone,
      'email': email,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Crea un PatientModel desde una entidad Patient
  factory PatientModel.fromEntity(Patient patient) {
    return PatientModel(
      id: patient.id,
      firstName: patient.firstName,
      lastName: patient.lastName,
      birthDate: patient.birthDate,
      phone: patient.phone,
      email: patient.email,
      createdAt: patient.createdAt,
      updatedAt: patient.updatedAt,
    );
  }

  /// Convierte el PatientModel a una entidad Patient
  Patient toEntity() {
    return Patient(
      id: id,
      firstName: firstName,
      lastName: lastName,
      birthDate: birthDate,
      phone: phone,
      email: email,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  PatientModel copyWith({
    int? id,
    String? firstName,
    String? lastName,
    DateTime? birthDate,
    String? phone,
    String? email,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PatientModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthDate: birthDate ?? this.birthDate,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
