import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hospital_appointments/core/utils/validation_utils.dart';
import 'package:hospital_appointments/domain/entities/appointment.dart';
import 'package:hospital_appointments/domain/entities/patient.dart';
import 'package:hospital_appointments/presentation/providers/appointment_provider.dart';
import 'package:hospital_appointments/presentation/providers/patient_provider.dart';
import 'package:hospital_appointments/core/utils/date_utils.dart' as app_date_utils;

/// Formulario para crear o editar una cita
/// 
/// Valida todos los campos antes de guardar.
/// Implementa buenas prácticas de UX y manejo de errores.
class AppointmentFormScreen extends StatefulWidget {
  final int? appointmentId;

  const AppointmentFormScreen({
    super.key,
    this.appointmentId,
  });

  @override
  State<AppointmentFormScreen> createState() => _AppointmentFormScreenState();
}

class _AppointmentFormScreenState extends State<AppointmentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  Patient? _selectedPatient;
  DateTime? _appointmentDate;
  TimeOfDay? _appointmentTime;
  bool _isLoading = false;

  bool get _isEditing => widget.appointmentId != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PatientProvider>().loadPatients();
      if (_isEditing) {
        _loadAppointment();
      }
    });
  }

  Future<void> _loadAppointment() async {
    setState(() => _isLoading = true);
    await context.read<AppointmentProvider>().selectAppointment(widget.appointmentId!);
    final appointment = context.read<AppointmentProvider>().selectedAppointment;
    if (appointment != null) {
      // Buscar el paciente en la lista cargada por su ID para evitar problemas de referencia
      final patientProvider = context.read<PatientProvider>();
      _selectedPatient = patientProvider.patients.firstWhere(
        (p) => p.id == appointment.patientId,
        orElse: () => appointment.patient!,
      );
      _appointmentDate = DateTime(
        appointment.appointmentDate.year,
        appointment.appointmentDate.month,
        appointment.appointmentDate.day,
      );
      _appointmentTime = TimeOfDay(
        hour: appointment.appointmentDate.hour,
        minute: appointment.appointmentDate.minute,
      );
      _notesController.text = appointment.notes ?? '';
    }
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Cita' : 'Nueva Cita'),
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
                    // Selector de paciente
                    Consumer<PatientProvider>(
                      builder: (context, patientProvider, child) {
                        if (patientProvider.isLoading) {
                          return const Card(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          );
                        }

                        if (patientProvider.patients.isEmpty) {
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  const Text('No hay pacientes registrados'),
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Aquí podrías navegar a crear paciente
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Por favor, registra un paciente primero'),
                                        ),
                                      );
                                    },
                                    child: const Text('Crear Paciente'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Paciente',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<Patient>(
                                  value: _selectedPatient,
                                  decoration: const InputDecoration(
                                    hintText: 'Selecciona un paciente',
                                    prefixIcon: Icon(Icons.person),
                                    border: OutlineInputBorder(),
                                  ),
                                  items: patientProvider.patients.map((patient) {
                                    return DropdownMenuItem(
                                      value: patient,
                                      child: Text(patient.fullName),
                                    );
                                  }).toList(),
                                  onChanged: _isEditing
                                      ? null // No permitir cambiar paciente en edición
                                      : (patient) {
                                          setState(() {
                                            _selectedPatient = patient;
                                          });
                                        },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Paciente es requerido';
                                    }
                                    return null;
                                  },
                                ),
                                if (_selectedPatient != null) ...[
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.surfaceVariant,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${_selectedPatient!.age} años',
                                          style: const TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                        Text(_selectedPatient!.phone),
                                        Text(_selectedPatient!.email),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Fecha de la cita
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Fecha de la Cita',
                          prefixIcon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          _appointmentDate != null
                              ? app_date_utils.DateUtils.formatDate(_appointmentDate!)
                              : 'Selecciona la fecha',
                          style: TextStyle(
                            color: _appointmentDate != null ? null : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    if (_appointmentDate == null)
                      Padding(
                        padding: const EdgeInsets.only(left: 12, top: 8),
                        child: Text(
                          'Fecha de la cita es requerida',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),

                    // Hora de la cita
                    InkWell(
                      onTap: () => _selectTime(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Hora de la Cita',
                          prefixIcon: Icon(Icons.access_time),
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          _appointmentTime != null
                              ? _appointmentTime!.format(context)
                              : 'Selecciona la hora',
                          style: TextStyle(
                            color: _appointmentTime != null ? null : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    if (_appointmentTime == null)
                      Padding(
                        padding: const EdgeInsets.only(left: 12, top: 8),
                        child: Text(
                          'Hora de la cita es requerida',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),

                    // Notas
                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        labelText: 'Notas (Opcional)',
                        hintText: 'Agrega notas sobre la cita...',
                        prefixIcon: Icon(Icons.note),
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    const SizedBox(height: 32),

                    // Botón de guardar
                    FilledButton.icon(
                      onPressed: _isLoading ? null : _saveAppointment,
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

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _appointmentDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Selecciona la fecha de la cita',
    );

    if (picked != null) {
      setState(() {
        _appointmentDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _appointmentTime ?? TimeOfDay.now(),
      helpText: 'Selecciona la hora de la cita',
    );

    if (picked != null) {
      setState(() {
        _appointmentTime = picked;
      });
    }
  }

  Future<void> _saveAppointment() async {
    // Validar que el paciente esté seleccionado
    if (_selectedPatient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona un paciente')),
      );
      return;
    }

    // Validar que la fecha esté seleccionada
    if (_appointmentDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona la fecha de la cita')),
      );
      return;
    }

    // Validar que la hora esté seleccionada
    if (_appointmentTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona la hora de la cita')),
      );
      return;
    }

    // Validar el formulario
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Combinar fecha y hora
    final appointmentDateTime = DateTime(
      _appointmentDate!.year,
      _appointmentDate!.month,
      _appointmentDate!.day,
      _appointmentTime!.hour,
      _appointmentTime!.minute,
    );

    setState(() => _isLoading = true);

    // Crear o actualizar la cita
    final appointment = Appointment(
      id: widget.appointmentId,
      patientId: _selectedPatient!.id!,
      appointmentDate: appointmentDateTime,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      patient: _selectedPatient,
    );

    final provider = context.read<AppointmentProvider>();
    final success = _isEditing
        ? await provider.updateAppointment(appointment)
        : await provider.createAppointment(appointment);

    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Cita actualizada correctamente'
                : 'Cita creada correctamente',
          ),
        ),
      );
    } else if (mounted) {
      final errorMessage = provider.errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage ?? 'Error al guardar la cita'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
