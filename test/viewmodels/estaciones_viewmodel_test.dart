
import 'package:bici_coruna/data/estaciones_repository.dart';
import 'package:bici_coruna/models/estacion.dart';
import 'package:bici_coruna/viewmodels/estaciones_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockEstacionesRepository extends Mock 
implements EstacionesRepository {}


void main(){
  late MockEstacionesRepository mockRepository;
  late EstacionesViewModel viewModel;

  setUp(() {
    mockRepository = MockEstacionesRepository();
    viewModel = EstacionesViewModel(repository: mockRepository);
  });

  group('EstacionesViewModel', (){
    test('Cambia el estado a loaded cuando la carga es correcta', () async{
      final estacionesMock = [
        Estacion(
          stationId: '1',
          name: 'Estación Test',
          lat: 0,
          lon: 0,
          capacity: 10,
          lastReported: 0,
          numBikesAvailable: 5,
          numDocksAvailable: 5,
          numBikesDisabled: 0,
          numDocksDisabled: 0,
          isInstalled: true,
          isRenting: true,
          isReturning: true,
        )
      ];

      when(() => mockRepository.getEstaciones())
          .thenAnswer((_) async => estacionesMock);

      await viewModel.cargarEstaciones();

      expect(viewModel.state, EstacionesState.loaded);
      expect(viewModel.estaciones.length, 1);
    });

    test('Cambia el estado a error cuando el repositorio lanza una excpeción', () async{
      when (() => mockRepository.getEstaciones())
          .thenThrow(Exception('Error de red'));

          await viewModel.cargarEstaciones();

          expect(viewModel.state, EstacionesState.error);
          expect(viewModel.estaciones.isEmpty, true);
    });
  });
}
