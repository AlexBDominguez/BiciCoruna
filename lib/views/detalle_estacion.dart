import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../viewmodels/estaciones_viewmodel.dart';
import '../models/estacion.dart';

class DetalleEstacion extends StatefulWidget {
  const DetalleEstacion({super.key});

  @override
  State<DetalleEstacion> createState() => _DetalleEstacionState();
}

class _DetalleEstacionState extends State<DetalleEstacion> {
  bool _isRefreshing = false;

  Future<void> _refrescarDatos() async {
    setState(() {
      _isRefreshing = true;
    });
    await context.read<EstacionesViewModel>().refrescarEstaciones();
    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String stationId =
        ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Estación'),
        actions: [
          IconButton(
            icon: _isRefreshing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.refresh),
            onPressed: _isRefreshing ? null : _refrescarDatos,
          ),
        ],
      ),
      body: Consumer<EstacionesViewModel>(
        builder: (context, viewModel, child) {
          final Estacion? estacion = viewModel.getEstacionPorId(stationId);

          if (estacion == null) {
            return const Center(
              child: Text('Estación no encontrada'),
            );
          }

          return RefreshIndicator(
            onRefresh: _refrescarDatos,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre de la estación
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.directions_bike,
                                  size: 32, color: Colors.blue),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  estacion.name,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.access_time,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                'Última actualización: ${_formatearFecha(estacion.lastReportedDate)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Estado de la estación
                  if (!estacion.isInstalled || !estacion.isRenting)
                    Card(
                      color: Colors.orange.shade100,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            const Icon(Icons.warning, color: Colors.orange),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                !estacion.isInstalled
                                    ? 'Estación no instalada'
                                    : 'Estación no operativa',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),

                  // Información principal en tarjetas
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.grid_on,
                          title: 'Puestos Totales',
                          value: estacion.capacity.toString(),
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.pedal_bike,
                          title: 'Bicis Disponibles',
                          value: estacion.numBikesAvailable.toString(),
                          color: estacion.numBikesAvailable > 0
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Tipos de bici
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Bicis por Tipo',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildBikeTypeInfo(
                                  icon: Icons.electric_bike,
                                  label: 'Eléctricas',
                                  count: estacion.numElectricBikes,
                                  color: Colors.amber,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildBikeTypeInfo(
                                  icon: Icons.pedal_bike,
                                  label: 'Mecánicas',
                                  count: estacion.numMechanicalBikes,
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Anclajes libres y rotos
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.lock_open,
                          title: 'Anclajes Libres',
                          value: estacion.numDocksAvailable.toString(),
                          color: estacion.numDocksAvailable > 0
                              ? Colors.teal
                              : Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.block,
                          title: 'Puestos Rotos',
                          value: estacion.numDocksDisabled.toString(),
                          color: Colors.red.shade300,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Bicis deshabilitadas
                  if (estacion.numBikesDisabled > 0)
                    Card(
                      color: Colors.red.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded,
                                color: Colors.red),
                            const SizedBox(width: 12),
                            Text(
                              'Bicis deshabilitadas: ${estacion.numBikesDisabled}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBikeTypeInfo({
    required IconData icon,
    required String label,
    required int count,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, size: 40, color: color),
        const SizedBox(height: 8),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  String _formatearFecha(DateTime fecha) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm:ss');
    return formatter.format(fecha);
  }
}