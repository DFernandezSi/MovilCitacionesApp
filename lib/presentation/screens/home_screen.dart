import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hospital_appointments/presentation/providers/patient_provider.dart';
import 'package:hospital_appointments/presentation/providers/appointment_provider.dart';
import 'package:hospital_appointments/presentation/screens/patients/patient_list_screen.dart';
import 'package:hospital_appointments/presentation/screens/appointments/appointment_list_screen.dart';

/// Pantalla principal con navegación por pestañas
/// 
/// Muestra dos pestañas principales: Pacientes y Citas.
/// Implementa una UI moderna con Material Design 3.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const PatientListScreen(),
    const AppointmentListScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Cargar datos iniciales
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PatientProvider>().loadPatients();
      context.read<AppointmentProvider>().loadAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Pacientes',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'Citas',
          ),
        ],
      ),
    );
  }
}
