import 'package:compaqi_test_app/domain/models/models.dart' show Location;
import 'package:compaqi_test_app/infrastructure/dtos/location_dto.dart';

class LocationResponseDTO {
  final bool ok;
  final LocationDTO location;

  LocationResponseDTO({required this.ok, required this.location});

  factory LocationResponseDTO.fromJson(Map<String, dynamic> json) {
    return LocationResponseDTO(ok: json['ok'], location: LocationDTO.fromJson(json['location']));
  }

  Location toDomain() {
    return location.toDomain();
  }
}
