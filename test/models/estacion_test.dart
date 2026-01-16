import 'package:bici_coruna/models/estacion.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  group('Modelo Estacion', (){
    test('Crea una estación correctamente desde station_information', (){
      final stationInfoJson = {
        'station_id': '123',
        'name': 'Plaza de Lugo',
        'lat': 43.3623,
        'lon': -8.4115,
        'capacity': 20,
      };
      final estacion = Estacion.fromStationInformation(stationInfoJson);

      expect(estacion.stationId, '123');
      expect(estacion.name, 'Plaza de Lugo');
      expect(estacion.capacity, 20);

      expect(estacion.numBikesAvailable, 0);
      expect(estacion.isInstalled, false);
    });

    test('mergeWithStatus combina correctamente la información de estado', (){
      final estacionBase = Estacion.fromStationInformation({
        'station_id': '123',
        'name': 'Plaza de Lugo',
        'lat': 43.3623,
        'lon': -8.4115,
        'capacity': 20,
      });

      final statusJson = {
        'last_reported': 1700000000,
        'num_bikes_available': 5,
        'num_docks_available': 10,
        'num_bikes_disabled': 1,
        'num_docks_disabled': 0,
        'is_installed': 1,
        'is_renting': 1,
        'is_returning': 1,
        'vehicle_types_available': [
          {'vehicle_type_id': 'bike', 'count': 3},
          {'vehicle_type_id': 'ebike', 'count': 2},
        ],
      };
      final estacionCompleta = estacionBase.mergeWithStatus(statusJson);

      expect(estacionCompleta.numBikesAvailable, 5);
      expect(estacionCompleta.isInstalled, true);
      expect(estacionCompleta.numElectricBikes, 2);
      expect(estacionCompleta.numMechanicalBikes, 3);
    });
  });
}