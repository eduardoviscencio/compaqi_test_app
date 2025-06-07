import 'package:compaqi_test_app/domain/models/models.dart' show User;

class UserDTO {
  String iss;
  String azp;
  String aud;
  double sub;
  String email;
  bool emailVerified;
  String atHash;
  String nonce;
  String name;
  String picture;
  String givenName;
  String familyName;
  int iat;
  int exp;

  UserDTO({
    required this.iss,
    required this.azp,
    required this.aud,
    required this.sub,
    required this.email,
    required this.emailVerified,
    required this.atHash,
    required this.nonce,
    required this.name,
    required this.picture,
    required this.givenName,
    required this.familyName,
    required this.iat,
    required this.exp,
  });

  factory UserDTO.fromJson(Map<String, dynamic> json) => UserDTO(
    iss: json["iss"],
    azp: json["azp"],
    aud: json["aud"],
    sub: json["sub"]?.toDouble(),
    email: json["email"],
    emailVerified: json["email_verified"],
    atHash: json["at_hash"],
    nonce: json["nonce"],
    name: json["name"],
    picture: json["picture"],
    givenName: json["given_name"],
    familyName: json["family_name"],
    iat: json["iat"],
    exp: json["exp"],
  );

  User toDomain() {
    return User(name: name, email: email, picture: picture);
  }
}
