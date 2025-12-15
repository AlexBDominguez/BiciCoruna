import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/estaciones_viewmodel.dart';

class SelectorEstaciones extends StatefulWidget {
  const SelectorEstaciones({super.key});

  @override
  State<SelectorEstaciones> createState() => _SelectorEstacionesState();
}

class _SelectorEstacionesState extends State<SelectorEstaciones> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Cargar estaciones al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EstacionesViewModel>().cargarEstaciones();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BiciCoruña'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar estación...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                context.read<EstacionesViewModel>().buscarEstacion(value);
              },
            ),
          ),
        ),
      ),
      body: Consumer<EstacionesViewModel>(
        builder: (context, viewModel, child) {
          // Estado: Loading
          if (viewModel.state == EstacionesState.loading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando estaciones...'),
                ],
              ),
            );
          }

          // Estado: Error
          if (viewModel.state == EstacionesState.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    viewModel.errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      viewModel.cargarEstaciones();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          // Estado: Loaded
          final estaciones = viewModel.estacionesFiltradas;

          if (estaciones.isEmpty) {
            return const Center(
              child: Text('No se encontraron estaciones'),
            );
          }

          return RefreshIndicator(
            onRefresh: viewModel.refrescarEstaciones,
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: estaciones.length,
              itemBuilder: (context, index) {
                final estacion = estaciones[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: estacion.numBikesAvailable > 0
                          ? Colors.green
                          : Colors.red,
                      child: Text(
                        '${estacion.numBikesAvailable}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(estacion.name),
                    subtitle: Text(
                      'Bicis: ${estacion.numBikesAvailable} | Anclajes: ${estacion.numDocksAvailable}',
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/detalleEstacion',
                        arguments: estacion.stationId,
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}