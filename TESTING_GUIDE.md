# Guía de Testing para BiciCoruña

## Preparación para Testing

Esta aplicación está lista para implementar tests. A continuación se describen los tipos de tests recomendados.

## 1. Tests Unitarios (Unit Tests)

### Modelo - estacion.dart

**Tests a implementar:**
- ✅ Creación de estación desde JSON (station_information)
- ✅ Merge de datos de estado (station_status)
- ✅ Getters calculados (numElectricBikes, numMechanicalBikes)
- ✅ Conversión a JSON
- ✅ Formateo de fecha (lastReportedDate)

**Ejemplo:**
```dart
test('Debe crear una estación desde station_information', () {
  final json = {
    'station_id': '1',
    'name': 'Estación Test',
    'lat': 43.3623,
    'lon': -8.4115,
    'capacity': 20,
  };
  
  final estacion = Estacion.fromStationInformation(json);
  
  expect(estacion.stationId, '1');
  expect(estacion.name, 'Estación Test');
  expect(estacion.capacity, 20);
});
```

### ViewModel - estaciones_viewmodel.dart

**Tests a implementar:**
- ✅ Estado inicial
- ✅ Carga de estaciones exitosa
- ✅ Manejo de errores
- ✅ Búsqueda de estaciones
- ✅ Filtrado por nombre
- ✅ Obtener estación por ID

**Ejemplo:**
```dart
test('Debe filtrar estaciones por nombre', () {
  final viewModel = EstacionesViewModel();
  // Mock de datos...
  
  viewModel.buscarEstacion('plaza');
  
  expect(viewModel.estacionesFiltradas.length, greaterThan(0));
  expect(
    viewModel.estacionesFiltradas.every(
      (e) => e.name.toLowerCase().contains('plaza')
    ),
    true
  );
});
```

### Repository - estaciones_repository.dart

**Tests a implementar:**
- ✅ Peticiones HTTP exitosas
- ✅ Manejo de errores HTTP
- ✅ Combinación de datos de ambas APIs
- ✅ Parsing de respuestas JSON
- ✅ Obtener estación por ID

**Ejemplo con mockito:**
```dart
test('Debe obtener lista de estaciones', () async {
  final mockClient = MockClient();
  final repository = EstacionesRepository(client: mockClient);
  
  when(mockClient.get(any))
    .thenAnswer((_) async => http.Response(mockJsonResponse, 200));
  
  final estaciones = await repository.getEstaciones();
  
  expect(estaciones, isNotEmpty);
});
```

## 2. Tests de Widget (Widget Tests)

### SelectorEstaciones

**Tests a implementar:**
- ✅ Renderiza el AppBar con título
- ✅ Muestra loading spinner cuando está cargando
- ✅ Muestra mensaje de error en caso de fallo
- ✅ Muestra lista de estaciones cuando se cargan
- ✅ Botón de reintentar funciona
- ✅ Campo de búsqueda filtra correctamente
- ✅ Navegación al detalle funciona

**Ejemplo:**
```dart
testWidgets('Debe mostrar loading mientras carga datos', (tester) async {
  await tester.pumpWidget(
    ChangeNotifierProvider(
      create: (_) => EstacionesViewModel(),
      child: MaterialApp(home: SelectorEstaciones()),
    ),
  );
  
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
  expect(find.text('Cargando estaciones...'), findsOneWidget);
});
```

### DetalleEstacion

**Tests a implementar:**
- ✅ Muestra nombre de la estación
- ✅ Muestra última actualización formateada
- ✅ Muestra puestos totales
- ✅ Muestra bicis disponibles
- ✅ Muestra bicis por tipo (eléctricas/mecánicas)
- ✅ Muestra anclajes libres
- ✅ Muestra puestos rotos
- ✅ Muestra alertas cuando la estación no está operativa
- ✅ Botón de refresh funciona

**Ejemplo:**
```dart
testWidgets('Debe mostrar información de la estación', (tester) async {
  final estacion = Estacion(
    stationId: '1',
    name: 'Test Station',
    // ... otros campos
  );
  
  await tester.pumpWidget(
    ChangeNotifierProvider(
      create: (_) => EstacionesViewModel()..estaciones = [estacion],
      child: MaterialApp(
        routes: {
          '/': (_) => SelectorEstaciones(),
          '/detalleEstacion': (_) => DetalleEstacion(),
        },
      ),
    ),
  );
  
  await tester.tap(find.byType(ListTile).first);
  await tester.pumpAndSettle();
  
  expect(find.text('Test Station'), findsOneWidget);
});
```

## 3. Tests de Integración (Integration Tests)

**Tests a implementar:**
- ✅ Flujo completo: Abrir app → Seleccionar estación → Ver detalle
- ✅ Refresh de datos en pantalla principal
- ✅ Búsqueda de estación → Selección → Ver detalle
- ✅ Navegación back desde detalle

**Ubicación:** `test/integration/`

**Ejemplo:**
```dart
testWidgets('Flujo completo de navegación', (tester) async {
  app.main();
  await tester.pumpAndSettle();
  
  // Esperar carga de datos
  await tester.pumpAndSettle(Duration(seconds: 3));
  
  // Buscar una estación
  await tester.enterText(find.byType(TextField), 'Plaza');
  await tester.pumpAndSettle();
  
  // Seleccionar primera estación
  await tester.tap(find.byType(ListTile).first);
  await tester.pumpAndSettle();
  
  // Verificar que estamos en detalle
  expect(find.text('Detalle de Estación'), findsOneWidget);
  
  // Volver atrás
  await tester.tap(find.byType(BackButton));
  await tester.pumpAndSettle();
  
  // Verificar que volvimos al listado
  expect(find.text('BiciCoruña'), findsOneWidget);
});
```

## 4. Estructura de Archivos de Test Recomendada

```
test/
├── unit/
│   ├── models/
│   │   └── estacion_test.dart
│   ├── viewmodels/
│   │   └── estaciones_viewmodel_test.dart
│   └── data/
│       └── estaciones_repository_test.dart
├── widget/
│   ├── selector_estaciones_test.dart
│   └── detalle_estacion_test.dart
├── integration/
│   └── app_flow_test.dart
└── fixtures/
    ├── station_information_response.json
    └── station_status_response.json
```

## 5. Mocks Necesarios

### Dependencias para Testing
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.0
  build_runner: ^2.4.0
  http_mock_adapter: ^0.5.0
```

### Mock del Repository
```dart
class MockEstacionesRepository extends Mock implements EstacionesRepository {}
```

### Mock del HTTP Client
```dart
class MockClient extends Mock implements http.Client {}
```

## 6. Comandos de Testing

```bash
# Ejecutar todos los tests
flutter test

# Ejecutar tests con cobertura
flutter test --coverage

# Ejecutar un test específico
flutter test test/unit/models/estacion_test.dart

# Ver reporte de cobertura
genhtml coverage/lcov.info -o coverage/html
# Abrir coverage/html/index.html
```

## 7. Datos de Prueba (Fixtures)

### station_information_response.json
```json
{
  "data": {
    "stations": [
      {
        "station_id": "1",
        "name": "Plaza de María Pita",
        "lat": 43.3623,
        "lon": -8.4115,
        "capacity": 20
      }
    ]
  }
}
```

### station_status_response.json
```json
{
  "data": {
    "stations": [
      {
        "station_id": "1",
        "num_bikes_available": 5,
        "num_docks_available": 15,
        "num_bikes_disabled": 0,
        "num_docks_disabled": 0,
        "is_installed": 1,
        "is_renting": 1,
        "is_returning": 1,
        "last_reported": 1641038400,
        "vehicle_types_available": [
          {"vehicle_type_id": "electric", "count": 2},
          {"vehicle_type_id": "mechanical", "count": 3}
        ]
      }
    ]
  }
}
```

## 8. Checklist de Testing

Antes de considerar la app lista para producción:

- [ ] Tests unitarios del modelo (100% cobertura)
- [ ] Tests unitarios del ViewModel (100% cobertura)
- [ ] Tests unitarios del Repository (100% cobertura)
- [ ] Tests de widget del selector (casos principales)
- [ ] Tests de widget del detalle (casos principales)
- [ ] Tests de integración del flujo completo
- [ ] Cobertura de código > 80%
- [ ] Todos los tests pasan
- [ ] Tests de errores de red
- [ ] Tests de estados de carga

## Próximos Pasos

1. **Crear archivos de test** según la estructura recomendada
2. **Implementar mocks** con mockito
3. **Escribir tests unitarios** empezando por el modelo
4. **Escribir tests de widget** para las vistas
5. **Implementar tests de integración**
6. **Medir y mejorar cobertura**
7. **Configurar CI/CD** para ejecutar tests automáticamente

---

**¡La aplicación está lista para comenzar con el testing!** 🧪

