import 'package:equatable/equatable.dart';

/// Entidad de dominio para un Paciente
/// 
/// Representa un paciente en el sistema con sus datos personales.
/// Usa Equatable para comparación de igualdad basada en valores.
/// Sigue el principio de inmutabilidad para mantener la integridad de los datos.
class Patient extends Equatable {
  final int? id;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final String phone;
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Patient({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.phone,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Obtiene el nombre completo del paciente
  String get fullName => '$firstName $lastName';

  /// Calcula la edad del paciente
  int get age {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  /// Crea una copia del paciente con algunos campos modificados
  Patient copyWith({
    int? id,
    String? firstName,
    String? lastName,
    DateTime? birthDate,
    String? phone,
    String? email,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Patient(
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

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        birthDate,
        phone,
        email,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'Patient{id: $id, fullName: $fullName, age: $age, phone: $phone, email: $email}';
  }
}
