import 'package:compaqi_test_app/domain/models/models.dart' show Location;

class LocationsDTO {
  bool ok;
  List<Location> locations;

  LocationsDTO({required this.ok, required this.locations});

  factory LocationsDTO.fromJson(Map<String, dynamic> json) => LocationsDTO(
    ok: json["ok"],
    locations: List<Location>.from(json["locations"].map((x) => Location.fromJson(x))),
  );

  List<Location> toDomain() {
    return locations;
  }
}
