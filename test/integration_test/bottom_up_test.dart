import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:bici_coruna/viewmodels/estaciones_viewmodel.dart';
import 'package:bici_coruna/models/estacion.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
      'Integración ascendente: carga completa de estaciones y cambio de estado',
      (WidgetTester tester) async {

    final viewModel = EstacionesViewModel();

    expect(viewModel.state, EstacionesState.initial);

    await viewModel.cargarEstaciones();

    expect(viewModel.state, EstacionesState.loaded);
    expect(viewModel.estaciones.isNotEmpty, true);

    final Estacion primera = viewModel.estaciones.first;
    expect(primera.stationId.isNotEmpty, true);
    expect(primera.name.isNotEmpty, true);
  });
}
