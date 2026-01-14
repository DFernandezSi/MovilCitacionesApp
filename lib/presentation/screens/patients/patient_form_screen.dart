import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hospital_appointments/core/utils/validation_utils.dart';
import 'package:hospital_appointments/domain/entities/patient.dart';
import 'package:hospital_appointments/presentation/providers/patient_provider.dart';
import 'package:hospital_appointments/core/utils/date_utils.dart' as app_date_utils;

/// Formulario para crear o editar un paciente
/// 
/// Valida todos los campos antes de guardar.
/// Implementa buenas prácticas de UX y manejo de errores.
class PatientFormScreen extends StatefulWidget {
  final int? patientId;

  const PatientFormScreen({
    super.key,
    this.patientId,
  });

  @override
  State<PatientFormScreen> createState() => _PatientFormScreenState();
}

class _PatientFormScreenState extends State<PatientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  DateTime? _birthDate;
  bool _isLoading = false;

  bool get _isEditing => widget.patientId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadPatient();
      });
    }
  }

  Future<void> _loadPatient() async {
    setState(() => _isLoading = true);
    await context.read<PatientProvider>().selectPatient(widget.patientId!);
    final patient = context.read<PatientProvider>().selectedPatient;
    if (patient != null) {
      _firstNameController.text = patient.firstName;
      _lastNameController.text = patient.lastName;
      _phoneController.text = patient.phone;
      _emailController.text = patient.email;
      _birthDate = patient.birthDate;
    }
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Paciente' : 'Nuevo Paciente'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Nombre
                    TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                        hintText: 'Ingresa el nombre',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: (value) =>
                          ValidationUtils.validateName(value, fieldName: 'Nombre'),
                    ),
                    const SizedBox(height: 16),

                    // Apellidos
                    TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Apellidos',
                        hintText: 'Ingresa los apellidos',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: (value) =>
                          ValidationUtils.validateName(value, fieldName: 'Apellidos'),
                    ),
                    const SizedBox(height: 16),

                    // Fecha de nacimiento
                    InkWell(
                      onTap: () => _selectBirthDate(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Fecha de Nacimiento',
                          prefixIcon: Icon(Icons.cake),
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          _birthDate != null
                              ? app_date_utils.DateUtils.formatDate(_birthDate!)
                              : 'Selecciona la fecha de nacimiento',
                          style: TextStyle(
                            color: _birthDate != null ? null : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    if (_birthDate == null)
                      Padding(
                        padding: const EdgeInsets.only(left: 12, top: 8),
                        child: Text(
                          'Fecha de nacimiento es requerida',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),

                    // Teléfono
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Teléfono',
                        hintText: '1234567890',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      validator: ValidationUtils.validatePhone,
                    ),
                    const SizedBox(height: 16),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'ejemplo@correo.com',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: ValidationUtils.validateEmail,
                    ),
                    const SizedBox(height: 32),

                    // Botón de guardar
                    FilledButton.icon(
                      onPressed: _isLoading ? null : _savePatient,
                      icon: const Icon(Icons.save),
                      label: Text(_isEditing ? 'Actualizar' : 'Guardar'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 150)),
      lastDate: DateTime.now(),
      helpText: 'Selecciona la fecha de nacimiento',
    );

    if (picked != null) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  Future<void> _savePatient() async {
    // Validar que la fecha de nacimiento esté seleccionada
    if (_birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona la fecha de nacimiento')),
      );
      return;
    }

    // Validar el formulario
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    // Crear o actualizar el paciente
    final patient = Patient(
      id: widget.patientId,
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      birthDate: _birthDate!,
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim().toLowerCase(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final provider = context.read<PatientProvider>();
    final success = _isEditing
        ? await provider.updatePatient(patient)
        : await provider.createPatient(patient);

    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Paciente actualizado correctamente'
                : 'Paciente creado correctamente',
          ),
        ),
      );
    } else if (mounted) {
      final errorMessage = provider.errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage ?? 'Error al guardar el paciente'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
