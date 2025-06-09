import 'package:compaqi_test_app/domain/models/models.dart' show Location;

class LocationDTO {
  String id;
  String tag;
  double latitude;
  double longitude;
  String placeId;
  String? sub;
  String? userEmail;

  LocationDTO({
    required this.id,
    required this.tag,
    required this.latitude,
    required this.longitude,
    required this.placeId,
    this.sub,
    this.userEmail,
  });

  factory LocationDTO.fromJson(Map<String, dynamic> json) => LocationDTO(
    id: json["id"],
    tag: json["tag"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    placeId: json["placeId"],
    sub: json["sub"],
    userEmail: json["user_email"],
  );

  Location toDomain() {
    return Location(
      id: id,
      tag: tag,
      latitude: latitude,
      longitude: longitude,
      placeId: placeId,
      sub: sub,
      userEmail: userEmail,
    );
  }
}
