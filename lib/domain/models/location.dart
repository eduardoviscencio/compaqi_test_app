import 'package:compaqi_test_app/infrastructure/dtos/dtos.dart' show LocationDTO;

class Location {
  String id;
  String tag;
  double latitude;
  double longitude;
  String placeId;
  String? sub;
  String? userEmail;

  Location({
    required this.id,
    required this.tag,
    required this.latitude,
    required this.longitude,
    required this.placeId,
    this.sub,
    this.userEmail,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    id: json["id"],
    tag: json["tag"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    placeId: json["placeId"],
    sub: json["sub"],
    userEmail: json["user_email"],
  );

  LocationDTO toDTO() {
    return LocationDTO(
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
