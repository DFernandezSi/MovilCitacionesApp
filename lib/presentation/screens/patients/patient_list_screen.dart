import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hospital_appointments/presentation/providers/patient_provider.dart';
import 'package:hospital_appointments/presentation/screens/patients/patient_detail_screen.dart';
import 'package:hospital_appointments/presentation/screens/patients/patient_form_screen.dart';

/// Pantalla de lista de pacientes
/// 
/// Muestra todos los pacientes con funcionalidad de búsqueda.
/// Permite navegar a los detalles y crear nuevos pacientes.
class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pacientes'),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Buscar paciente aqui...',
              leading: const Icon(Icons.search),
              trailing: [
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      context.read<PatientProvider>().searchPatients('');
                    },
                  ),
              ],
              onChanged: (value) {
                context.read<PatientProvider>().searchPatients(value);
              },
            ),
          ),
        ),
      ),
      body: Consumer<PatientProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.patients.isEmpty) {
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
                    onPressed: () => provider.loadPatients(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (provider.patients.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    provider.searchQuery.isEmpty
                        ? 'No hay pacientes registrados'
                        : 'No se encontraron pacientes',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  if (provider.searchQuery.isEmpty) ...[
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => _navigateToForm(context, null),
                      icon: const Icon(Icons.add),
                      label: const Text('Agregar paciente'),
                    ),
                  ],
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadPatients(),
            child: ListView.builder(
              itemCount: provider.patients.length,
              itemBuilder: (context, index) {
                final patient = provider.patients[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                        Text('${patient.age} años • ${patient.phone}'),
                        Text(patient.email, style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _navigateToDetail(context, patient.id!),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToForm(context, null),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Paciente'),
      ),
    );
  }

  void _navigateToDetail(BuildContext context, int patientId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientDetailScreen(patientId: patientId),
      ),
    );
  }

  void _navigateToForm(BuildContext context, int? patientId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientFormScreen(patientId: patientId),
      ),
    );
  }
}
