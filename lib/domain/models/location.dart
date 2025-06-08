class Location {
  String tag;
  double latitude;
  double longitude;
  String placeId;
  String sub;
  String userEmail;
  String id;

  Location({
    required this.tag,
    required this.latitude,
    required this.longitude,
    required this.placeId,
    required this.sub,
    required this.userEmail,
    required this.id,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    tag: json["tag"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    placeId: json["placeId"],
    sub: json["sub"],
    userEmail: json["user_email"],
    id: json["id"],
  );
}
