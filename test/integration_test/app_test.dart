
import 'package:bici_coruna/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Prueba de sistema: navegación desde lista de estaciones a detalle',
    (WidgetTester tester) async{
      await tester.pumpWidget(MyApp());

      await tester.pumpAndSettle(const Duration(seconds: 10));

      expect(find.byType(ListTile), findsWidgets);

      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();

      expect(find.text('Detalles de la Estación'), findsOneWidget);
      expect(find.byIcon(Icons.directions_bike), findsWidgets);
    },
  );
}