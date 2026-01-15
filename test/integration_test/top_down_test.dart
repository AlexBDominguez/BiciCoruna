import 'package:bici_coruna/data/estaciones_repository.dart';
import 'package:bici_coruna/models/estacion.dart';
import 'package:bici_coruna/viewmodels/estaciones_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockEstacionesRepository extends Mock implements EstacionesRepository {
  void main() {
    late MockEstacionesRepository mockRepository;
    late EstacionesViewModel viewModel;

    setUp(() {
      mockRepository = MockEstacionesRepository();
      viewModel = EstacionesViewModel(repository: mockRepository);
    });

    test(
      'Integración descendente: el ViewModel cambia a loaded cuando el repositorio devuelve datos',
      () async {
        final estacionesFake = [
          Estacion(
            stationId: '1',
            name: 'Estación Test',
            lat: 0.0,
            lon: 0.0,
            capacity: 20,
            lastReported: 1700000000,
            numBikesAvailable: 5,
            numDocksAvailable: 10,
            numBikesDisabled: 0,
            numDocksDisabled: 0,
            isInstalled: true,
            isRenting: true,
            isReturning: true,
            
          ),
        ];
        // Simulamos respuesta correcta del repositorio
        when(
          () => mockRepository.getEstaciones(),
        ).thenAnswer((_) async => estacionesFake);

        expect(viewModel.state, EstacionesState.initial);

        await viewModel.cargarEstaciones();

        expect(viewModel.state, EstacionesState.loaded);
        expect(viewModel.estaciones.length, 1);
        expect(viewModel.estaciones.first.name, 'Estación Test');
      },
    );
  }
}
