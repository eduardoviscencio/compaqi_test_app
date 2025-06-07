import 'dart:convert';

Map<String, dynamic> parseIdToken(String idToken) {
  final parts = idToken.split('.');
  assert(parts.length == 3);

  final payload = base64Url.normalize(parts[1]);
  final decoded = utf8.decode(base64Url.decode(payload));
  final payloadMap = json.decode(decoded) as Map<String, dynamic>;

  return payloadMap;
}
