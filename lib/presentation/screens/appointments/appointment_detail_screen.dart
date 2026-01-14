import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hospital_appointments/presentation/providers/appointment_provider.dart';
import 'package:hospital_appointments/presentation/screens/appointments/appointment_form_screen.dart';
import 'package:hospital_appointments/presentation/screens/patients/patient_detail_screen.dart';
import 'package:hospital_appointments/core/utils/date_utils.dart' as app_date_utils;

/// Pantalla de detalle de una cita
/// 
/// Muestra toda la información de la cita y del paciente asociado.
/// Permite editar y eliminar la cita.
class AppointmentDetailScreen extends StatefulWidget {
  final int appointmentId;

  const AppointmentDetailScreen({
    super.key,
    required this.appointmentId,
  });

  @override
  State<AppointmentDetailScreen> createState() => _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppointmentProvider>().selectAppointment(widget.appointmentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de la Cita'),
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
      body: Consumer<AppointmentProvider>(
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
                      provider.selectAppointment(widget.appointmentId);
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          final appointment = provider.selectedAppointment;
          if (appointment == null) {
            return const Center(child: Text('Cita no encontrada'));
          }

          final patient = appointment.patient;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header con estado de la cita
                Container(
                  width: double.infinity,
                  color: appointment.isPast
                      ? Colors.grey[300]
                      : appointment.isToday
                          ? Colors.orange[100]
                          : Colors.green[100],
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 64,
                        color: appointment.isPast
                            ? Colors.grey[700]
                            : appointment.isToday
                                ? Colors.orange[700]
                                : Colors.green[700],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        app_date_utils.DateUtils.formatDate(appointment.appointmentDate),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        app_date_utils.DateUtils.formatTime(appointment.appointmentDate),
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 8),
                      Chip(
                        label: Text(
                          appointment.isPast
                              ? 'CITA PASADA'
                              : appointment.isToday
                                  ? 'CITA HOY'
                                  : 'CITA FUTURA',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        backgroundColor: appointment.isPast
                            ? Colors.grey[400]
                            : appointment.isToday
                                ? Colors.orange[300]
                                : Colors.green[300],
                      ),
                    ],
                  ),
                ),

                // Información del paciente
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Paciente',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (patient != null)
                            TextButton(
                              onPressed: () => _navigateToPatient(context, patient.id!),
                              child: const Text('Ver detalle'),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (patient != null) ...[
                        Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                              child: Text(
                                patient.firstName[0].toUpperCase(),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              patient.fullName,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text('${patient.age} años'),
                                Text(patient.phone),
                                Text(patient.email),
                              ],
                            ),
                            isThreeLine: true,
                          ),
                        ),
                      ] else ...[
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              'Información del paciente no disponible',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Notas de la cita
                if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Notas',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              appointment.notes!,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Información de creación
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Información del Registro',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Creada: ${app_date_utils.DateUtils.formatDateTime(appointment.createdAt)}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      Text(
                        'Actualizada: ${app_date_utils.DateUtils.formatDateTime(appointment.updatedAt)}',
                        style: TextStyle(color: Colors.grey[600]),
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
        builder: (context) => AppointmentFormScreen(appointmentId: widget.appointmentId),
      ),
    );
  }

  void _navigateToPatient(BuildContext context, int patientId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientDetailScreen(patientId: patientId),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Cita'),
        content: const Text(
          '¿Estás seguro de que deseas eliminar esta cita? '
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
      final success = await context.read<AppointmentProvider>().deleteAppointment(widget.appointmentId);
      if (success && context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cita eliminada correctamente')),
        );
      } else if (context.mounted) {
        final errorMessage = context.read<AppointmentProvider>().errorMessage;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage ?? 'Error al eliminar cita')),
        );
      }
    }
  }
}
