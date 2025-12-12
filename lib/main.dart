import 'package:bici_coruna/views/selector_estaciones.dart';
import 'package:flutter/material.dart';
import 'package:bici_coruna/views/detalle_estacion.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Estaciones App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SelectorEstaciones(),
      routes: {
        '/detalleEstacion': (context) => const DetalleEstacion(),
      },
    );


  }

}