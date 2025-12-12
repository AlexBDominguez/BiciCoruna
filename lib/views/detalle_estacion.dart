import 'package:flutter/material.dart';

class DetalleEstacion extends StatelessWidget {
  const DetalleEstacion({super.key});

  @override
  Widget build(BuildContext context) {
    final String estacion =
        ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de $estacion'),
      ),
      body: Center(
        child: Text(
          'Aquí se muestran los detalles de $estacion',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}