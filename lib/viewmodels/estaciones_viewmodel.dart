import 'package:bici_coruna/data/estaciones_repository.dart';
import 'package:bici_coruna/models/estacion.dart';
import 'package:flutter/material.dart';

enum EstacionesState {
  initial,
  loading,
  loaded,
  error,
}

class EstacionesViewModel extends ChangeNotifier {
  final EstacionesRepository _repository = EstacionesRepository();

  //Estado actual
  EstacionesState _state = EstacionesState.initial;
  EstacionesState get state => _state;

  //Lista de estaciones
  List<Estacion> _estaciones = [];
  List<Estacion> get estaciones => _estaciones;

  //Mensaje de rror
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  //Lista filtrada para búsqueda
  List<Estacion> _estacionesFiltradas = [];
  List<Estacion> get estacionesFiltradas => _estacionesFiltradas;

  //Cargar estaciones desde el repositorio
  Future<void> cargarEstaciones() async{
    _state = EstacionesState.loading;
    notifyListeners();

    try 
    {
      _estaciones = await _repository.getEstaciones();
      _estacionesFiltradas = _estaciones;
      _state = EstacionesState.loaded;
      _errorMessage = '';
    } catch (e) {
      _state = EstacionesState.error;
      _errorMessage = "No se pudieron cargar las estaciones. Inténtalo de nuevo.";
      _estaciones = [];
      _estacionesFiltradas = [];
    }
    notifyListeners();
  }

  //Buscar estaciones por nombre
  void buscarEstacion(String query) {
    if (query.isEmpty) {
      _estacionesFiltradas = _estaciones;
    } else {
      _estacionesFiltradas = _estaciones
          .where((estacion) =>
              estacion.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  // Obtener una estación por su ID
  Estacion? getEstacionPorId(String stationId){
    try {
      return _estaciones.firstWhere(
        (estacion) => estacion.stationId == stationId,
      );
    } catch (e) {
      return null;
    }
  }

  //Recargar datos
  Future<void> refrescarEstaciones() async {
    await cargarEstaciones();
  }
}