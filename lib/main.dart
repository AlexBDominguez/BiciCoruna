import 'package:bici_coruna/viewmodels/estaciones_viewmodel.dart';
import 'package:bici_coruna/views/selector_estaciones.dart';
import 'package:flutter/material.dart';
import 'package:bici_coruna/views/detalle_estacion.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EstacionesViewModel(),
      child: MaterialApp(
        title: 'Bici Coruña',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SelectorEstaciones(),
          '/detalleEstacion': (context) => const DetalleEstacion(),
        },
      ),
    );
  }
}