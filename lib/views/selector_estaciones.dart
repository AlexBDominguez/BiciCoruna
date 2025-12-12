import 'package:flutter/material.dart';

List<String> estaciones = [
  'Estación Central',
  'Estación Norte',
  'Estación Sur',
  'Estación Este',
  'Estación Oeste',
];

class SelectorEstaciones extends StatefulWidget{
  const SelectorEstaciones({super.key});

  @override
    State<SelectorEstaciones> createState() => _SelectorEstacionesState();
}

class _SelectorEstacionesState extends State<SelectorEstaciones>{
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selector de Estaciones'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: estaciones.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(estaciones[index]),
                onTap: () {
                 Navigator.pushNamed(
                  context,
                  '/detalleEstacion',
                  arguments: estaciones[index],
                 );
                },
              ),
            );
          },
      ),
    )
    );
  }
}

