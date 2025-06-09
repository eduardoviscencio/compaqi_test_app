import 'package:compaqi_test_app/domain/models/models.dart' show Location;
import 'package:compaqi_test_app/infrastructure/dtos/dtos.dart' show LocationDTO;

class LocationsResponseDTO {
  bool ok;
  List<LocationDTO> locations;

  LocationsResponseDTO({required this.ok, required this.locations});

  factory LocationsResponseDTO.fromJson(Map<String, dynamic> json) => LocationsResponseDTO(
    ok: json["ok"],
    locations: List<LocationDTO>.from(json["locations"].map((x) => LocationDTO.fromJson(x))),
  );

  List<Location> toDomain() {
    return locations.map((dto) => dto.toDomain()).toList();
  }
}
