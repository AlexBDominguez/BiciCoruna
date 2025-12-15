import 'dart:convert';

import 'package:bici_coruna/models/estacion.dart';
import 'package:http/http.dart' as http;

class EstacionesRepository {
  static const String _stationInfoUrl =
      'https://acoruna.publicbikesystem.net/customer/gbfs/v2/gl/station_information';
  static const String _stationStatusUrl =
      'https://acoruna.publicbikesystem.net/customer/gbfs/v2/gl/station_status';

  // Obtiene todas las estaciones con la info completa
  Future<List<Estacion>> getEstaciones() async {
    try {
      // Hacer ambas peticiones en paralelo
      final responses = await Future.wait([
        http.get(Uri.parse(_stationInfoUrl)),
        http.get(Uri.parse(_stationStatusUrl)),
      ]);

      final infoResponse = responses[0];
      final statusResponse = responses[1];

      // Manejo de errores básicos
      if (infoResponse.statusCode != 200) {
        throw Exception('Error al cargar la información de las estaciones');
      }
      if (statusResponse.statusCode != 200) {
        throw Exception('Error al cargar el estado de las estaciones');
      }

      //Parsear las respuestas JSON
      final infoData = json.decode(infoResponse.body);
      final statusData = json.decode(statusResponse.body);

      //Extraer listas de estaciones
      final List<dynamic> stationsInfo =
          infoData['data']['stations'] as List<dynamic>;
      final List<dynamic> stationsStatus =
          statusData['data']['stations'] as List<dynamic>;

      //Crear un mapa de status para acceso rápido
      final Map<String, dynamic> statusMap = {
        for (var status in stationsStatus)
          status['station_id'] as String: status,
      };

      //Combinar info y status
      List<Estacion> estaciones = [];
      for (var stationInfo in stationsInfo) {
        final stationId = stationInfo['station_id'] as String;
        final estacion = Estacion.fromStationInformation(stationInfo);

        //Si existe status, combinarlo
        if (statusMap.containsKey(stationId)) {
          estaciones.add(estacion.mergeWithStatus(statusMap[stationId]));
        } else {
          estaciones.add(estacion);
        }
      }

      return estaciones;
    } catch (e) {
      throw Exception('Error al obtener datos de las estaciones: $e');
    }
  }

// Obtener una estación por su ID
  Future<Estacion> getEstacionPorId(String stationId) async {
    final estaciones = await getEstaciones();
    try {
      return estaciones.firstWhere(
        (estacion) => estacion.stationId == stationId,
      );
    } catch (e) {
      throw Exception('Estación con ID $stationId no encontrada');
    }
  }
}
