import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hospital_appointments/presentation/providers/patient_provider.dart';
import 'package:hospital_appointments/presentation/providers/appointment_provider.dart';
import 'package:hospital_appointments/presentation/screens/patients/patient_form_screen.dart';
import 'package:hospital_appointments/presentation/screens/appointments/appointment_list_screen.dart';
import 'package:hospital_appointments/core/utils/date_utils.dart' as app_date_utils;

/// Pantalla de detalle de un paciente
/// 
/// Muestra toda la información del paciente y sus citas.
/// Permite editar y eliminar el paciente.
class PatientDetailScreen extends StatefulWidget {
  final int patientId;

  const PatientDetailScreen({
    super.key,
    required this.patientId,
  });

  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PatientProvider>().selectPatient(widget.patientId);
      context.read<AppointmentProvider>().loadAppointmentsByPatient(widget.patientId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Paciente'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _navigateToEdit(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: Consumer<PatientProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(provider.errorMessage!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      provider.selectPatient(widget.patientId);
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          final patient = provider.selectedPatient;
          if (patient == null) {
            return const Center(child: Text('Paciente no encontrado'));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header con información principal
                Container(
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.primaryContainer,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          patient.firstName[0].toUpperCase(),
                          style: TextStyle(
                            fontSize: 48,
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        patient.fullName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${patient.age} años',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),

                // Información de contacto
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Información de Contacto',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _InfoCard(
                        icon: Icons.phone,
                        label: 'Teléfono',
                        value: patient.phone,
                      ),
                      const SizedBox(height: 8),
                      _InfoCard(
                        icon: Icons.email,
                        label: 'Email',
                        value: patient.email,
                      ),
                      const SizedBox(height: 8),
                      _InfoCard(
                        icon: Icons.cake,
                        label: 'Fecha de Nacimiento',
                        value: app_date_utils.DateUtils.formatDate(patient.birthDate),
                      ),
                    ],
                  ),
                ),

                const Divider(),

                // Lista de citas
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Citas Médicas',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () => _navigateToAllAppointments(context),
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text('Ver todas'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Consumer<AppointmentProvider>(
                        builder: (context, appointmentProvider, child) {
                          if (appointmentProvider.isLoading) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          final appointments = appointmentProvider.appointments;
                          if (appointments.isEmpty) {
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Center(
                                  child: Text(
                                    'No hay citas registradas',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ),
                              ),
                            );
                          }

                          return Column(
                            children: appointments.take(3).map((appointment) {
                              return Card(
                                child: ListTile(
                                  leading: Icon(
                                    Icons.calendar_today,
                                    color: appointment.isPast
                                        ? Colors.grey
                                        : Theme.of(context).colorScheme.primary,
                                  ),
                                  title: Text(
                                    app_date_utils.DateUtils.formatDateTime(appointment.appointmentDate),
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: appointment.notes != null
                                      ? Text(appointment.notes!)
                                      : null,
                                  trailing: Chip(
                                    label: Text(
                                      appointment.isPast
                                          ? 'Pasada'
                                          : appointment.isToday
                                              ? 'Hoy'
                                              : 'Futura',
                                    ),
                                    backgroundColor: appointment.isPast
                                        ? Colors.grey[300]
                                        : appointment.isToday
                                            ? Colors.orange[100]
                                            : Colors.green[100],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _navigateToEdit(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientFormScreen(patientId: widget.patientId),
      ),
    );
  }

  void _navigateToAllAppointments(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AppointmentListScreen(),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Paciente'),
        content: const Text(
          '¿Estás seguro de que deseas eliminar este paciente? '
          'Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success = await context.read<PatientProvider>().deletePatient(widget.patientId);
      if (success && context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Paciente eliminado correctamente')),
        );
      } else if (context.mounted) {
        final errorMessage = context.read<PatientProvider>().errorMessage;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage ?? 'Error al eliminar paciente')),
        );
      }
    }
  }
}

/// Widget para mostrar una tarjeta de información
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
