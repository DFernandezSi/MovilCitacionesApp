import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hospital_appointments/presentation/providers/appointment_provider.dart';
import 'package:hospital_appointments/presentation/screens/appointments/appointment_detail_screen.dart';
import 'package:hospital_appointments/presentation/screens/appointments/appointment_form_screen.dart';
import 'package:hospital_appointments/core/utils/date_utils.dart' as app_date_utils;

/// Pantalla de lista de citas
/// 
/// Muestra todas las citas con opciones de filtrado por día o mes.
/// Permite navegar a los detalles y crear nuevas citas.
class AppointmentListScreen extends StatefulWidget {
  const AppointmentListScreen({super.key});

  @override
  State<AppointmentListScreen> createState() => _AppointmentListScreenState();
}

class _AppointmentListScreenState extends State<AppointmentListScreen> {
  String _filterType = 'all'; // 'all', 'day', 'month'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Citas Médicas'),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                _filterType = value;
              });
              if (value == 'all') {
                context.read<AppointmentProvider>().loadAppointments();
              } else if (value == 'day') {
                _selectDay(context);
              } else if (value == 'month') {
                _selectMonth(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Row(
                  children: [
                    Icon(Icons.list),
                    SizedBox(width: 8),
                    Text('Todas las citas'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'day',
                child: Row(
                  children: [
                    Icon(Icons.calendar_today),
                    SizedBox(width: 8),
                    Text('Filtrar por día'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'month',
                child: Row(
                  children: [
                    Icon(Icons.calendar_month),
                    SizedBox(width: 8),
                    Text('Filtrar por mes'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Mostrar filtro activo
          Consumer<AppointmentProvider>(
            builder: (context, provider, child) {
              if (provider.selectedDate != null) {
                return Container(
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.primaryContainer,
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.filter_list),
                      const SizedBox(width: 8),
                      Text(
                        'Día: ${app_date_utils.DateUtils.formatDate(provider.selectedDate!)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          setState(() => _filterType = 'all');
                          provider.loadAppointments();
                        },
                        child: const Text('Limpiar'),
                      ),
                    ],
                  ),
                );
              } else if (provider.selectedMonth != null && provider.selectedYear != null) {
                final monthNames = [
                  'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
                  'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
                ];
                return Container(
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.primaryContainer,
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.filter_list),
                      const SizedBox(width: 8),
                      Text(
                        'Mes: ${monthNames[provider.selectedMonth! - 1]} ${provider.selectedYear}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          setState(() => _filterType = 'all');
                          provider.loadAppointments();
                        },
                        child: const Text('Limpiar'),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // Lista de citas
          Expanded(
            child: Consumer<AppointmentProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.appointments.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                        const SizedBox(height: 16),
                        Text(
                          provider.errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => provider.loadAppointments(),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }

                if (provider.appointments.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_today_outlined, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No hay citas registradas',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => _navigateToForm(context, null),
                          icon: const Icon(Icons.add),
                          label: const Text('Agregar cita'),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => provider.loadAppointments(),
                  child: ListView.builder(
                    itemCount: provider.appointments.length,
                    itemBuilder: (context, index) {
                      final appointment = provider.appointments[index];
                      final patient = appointment.patient;

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: appointment.isPast
                                ? Colors.grey
                                : appointment.isToday
                                    ? Colors.orange
                                    : Theme.of(context).colorScheme.primary,
                            child: Icon(
                              Icons.calendar_today,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            patient?.fullName ?? 'Paciente desconocido',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                app_date_utils.DateUtils.formatDateTime(appointment.appointmentDate),
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                              if (appointment.notes != null) ...[
                                const SizedBox(height: 2),
                                Text(
                                  appointment.notes!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ],
                          ),
                          isThreeLine: appointment.notes != null,
                          trailing: Chip(
                            label: Text(
                              appointment.isPast
                                  ? 'Pasada'
                                  : appointment.isToday
                                      ? 'Hoy'
                                      : 'Futura',
                              style: const TextStyle(fontSize: 12),
                            ),
                            backgroundColor: appointment.isPast
                                ? Colors.grey[300]
                                : appointment.isToday
                                    ? Colors.orange[100]
                                    : Colors.green[100],
                          ),
                          onTap: () => _navigateToDetail(context, appointment.id!),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToForm(context, null),
        icon: const Icon(Icons.add),
        label: const Text('Nueva Cita'),
      ),
    );
  }

  Future<void> _selectDay(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Selecciona un día',
    );

    if (picked != null && mounted) {
      context.read<AppointmentProvider>().loadAppointmentsByDay(picked);
    }
  }

  Future<void> _selectMonth(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
      helpText: 'Selecciona un mes',
      initialDatePickerMode: DatePickerMode.year,
    );

    if (picked != null && mounted) {
      context.read<AppointmentProvider>().loadAppointmentsByMonth(picked.year, picked.month);
    }
  }

  void _navigateToDetail(BuildContext context, int appointmentId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentDetailScreen(appointmentId: appointmentId),
      ),
    );
  }

  void _navigateToForm(BuildContext context, int? appointmentId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentFormScreen(appointmentId: appointmentId),
      ),
    );
  }
}
