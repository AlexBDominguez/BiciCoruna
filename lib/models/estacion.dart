class Estacion {
  //Información de la estación
  final String stationId;
  final String name;
  final double lat;
  final double lon;
  final int capacity;

  //Estado de la estación
  final int lastReported;
  final int numBikesAvailable;
  final int numDocksAvailable;
  final int numBikesDisabled;
  final int numDocksDisabled;
  final bool isInstalled;
  final bool isRenting;
  final bool isReturning;

  // Tipos de Vehículo
  final Map<String, int> vehicleTypesAvailable;

  Estacion({
    required this.stationId,
    required this.name,
    required this.lat,
    required this.lon,
    required this.capacity,
    required this.lastReported,
    required this.numBikesAvailable,
    required this.numDocksAvailable,
    required this.numBikesDisabled,
    required this.numDocksDisabled,
    required this.isInstalled,
    required this.isRenting,
    required this.isReturning,
    this.vehicleTypesAvailable = const {},
  });

  // Factory para crear desde station_information
  factory Estacion.fromStationInformation(Map<String, dynamic> json) {
    return Estacion(
      stationId: json['station_id'] as String,
      name: json['name'] as String,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      capacity: json['capacity'] as int,
      lastReported: 0,
      numBikesAvailable: 0,
      numDocksAvailable: 0,
      numBikesDisabled: 0,
      numDocksDisabled: 0,
      isInstalled: false,
      isRenting: false,
      isReturning: false,
    );
  }

  // Método para combinar con datos de status
  Estacion mergeWithStatus(Map<String, dynamic> statusJson) {
    // Parsear vehicle_types_available
    Map<String, int> vehicleTypes = {};
    if (statusJson['vehicle_types_available'] != null) {
      List<dynamic> types = statusJson['vehicle_types_available'] as List;
      for (var type in types) {
        String vehicleTypeId = type['vehicle_type_id'] as String;
        int count = type['count'] as int;
        vehicleTypes[vehicleTypeId] = count;
      }
    }

    return Estacion(
      stationId: stationId,
      name: name,
      lat: lat,
      lon: lon,
      capacity: capacity,
      lastReported: statusJson['last_reported'] as int,
      numBikesAvailable: statusJson['num_bikes_available'] as int,
      numDocksAvailable: statusJson['num_docks_available'] as int,
      numBikesDisabled: statusJson['num_bikes_disabled'] as int,
      numDocksDisabled: statusJson['num_docks_disabled'] as int,
      isInstalled: statusJson['is_installed'] == 1,
      isRenting: statusJson['is_renting'] == 1,
      isReturning: statusJson['is_returning'] == 1,
      vehicleTypesAvailable: vehicleTypes,
    );
  }

  // Getter para fecha formateada
  DateTime get lastReportedDate {
    return DateTime.fromMillisecondsSinceEpoch(lastReported * 1000);
  }

  // Getters para tipos de bicis
  int get numElectricBikes => vehicleTypesAvailable['electric'] ?? 0;
  int get numMechanicalBikes => vehicleTypesAvailable['mechanical'] ?? 0;

  Map<String, dynamic> toJson() {
    return {
      'station_id': stationId,
      'name': name,
      'lat': lat,
      'lon': lon,
      'capacity': capacity,
      'last_reported': lastReported,
      'num_bikes_available': numBikesAvailable,
      'num_docks_available': numDocksAvailable,
      'num_bikes_disabled': numBikesDisabled,
      'num_docks_disabled': numDocksDisabled,
      'is_installed': isInstalled ? 1 : 0,
      'is_renting': isRenting ? 1 : 0,
      'is_returning': isReturning ? 1 : 0,
      'vehicle_types_available': vehicleTypesAvailable,
    };
  }

  @override
  String toString() {
    return 'Estacion{id: $stationId, name: $name, bikes: $numBikesAvailable}';
  }
}
