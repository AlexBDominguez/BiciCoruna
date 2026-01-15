import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:bici_coruna/data/estaciones_repository.dart';

class MockHttpClient extends Mock implements http.Client {}

class FakeUri extends Fake implements Uri {}

void main(){
  late MockHttpClient mockClient;
  late EstacionesRepository repository;

  setUpAll((){
    registerFallbackValue(Uri.parse('http://example.com'));
  });

  setUp((){
    mockClient = MockHttpClient();
    repository = EstacionesRepository(client: mockClient);
  });

  group('EstacionesRepository', (){
    test('Devuelve una lista de estaciones cuando la API responde correctamente', ()async {
      when(() => mockClient.get(any())).thenAnswer((invocation) async{
        final url = invocation.positionalArguments.first.toString();

        if (url.contains('station_information')){
          return http.Response(jsonEncode({
            'data':{
              'stations': [
                {
                  'station_id': '1',
                  'name': 'Estación Test',
                  'lat': 43.0,
                  'lon': -8.0,
                  'capacity': 10,
                }
              ]
            }
          }), 200);
        } else{
          return http.Response(jsonEncode({
            'data': {
              'stations': [
                {
                  'station_id': '1',
                  'last_reported': 1700000000,
                  'num_bikes_available': 3,
                  'num_docks_available': 5,
                  'num_bikes_disabled': 0,
                  'num_docks_disabled': 0,
                  'is_installed': 1,
                  'is_renting': 1,
                  'is_returning': 1,
                  'vehicle_types_available': []
                }
              ]
            }
          }),200);
        }
      });
      final estaciones = await repository.getEstaciones();

      expect(estaciones.length, 1);
      expect(estaciones.first.stationId, '1');
      expect(estaciones.first.numBikesAvailable, 3);
  });

  test('Lanza una excepción cuando falla una petición HTTP', () async{
      when(() => mockClient.get(any())).thenAnswer(
        (_)async => http.Response('Error', 500)
    );

    expect(
      () => repository.getEstaciones(),
      throwsException,
    );
  });
  });
  }