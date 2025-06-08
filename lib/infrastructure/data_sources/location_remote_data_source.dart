import 'package:http/http.dart' as http;

import 'package:compaqi_test_app/infrastructure/config/config.dart' show Environment;
import 'package:compaqi_test_app/infrastructure/data_sources/data_sources.dart'
    show LocationDataSource;
import 'package:compaqi_test_app/infrastructure/services/services.dart' show TokenService;

class LocationRemoteDataSource implements LocationDataSource {
  late String _baseUrl;

  LocationRemoteDataSource() {
    _baseUrl = Environment.apiUrl;
  }

  @override
  Future<http.Response> fetchLocations() async {
    try {
      final Uri uri = Uri.https(_baseUrl, '/api/locations');

      final token = await TokenService.getIdToken();

      if (token == null || token.isEmpty) {
        throw Exception('Access token is not available');
      }

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Future<void> postLocation(Location location) async {
  //   final response = await client.post(
  //     Uri.parse('$baseUrl/locations'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: json.encode(location.toJson()),
  //   );

  //   if (response.statusCode != 201 && response.statusCode != 200) {
  //     throw Exception('Failed to save location');
  //   }
  // }

  // Future<void> removeLocation(String id) async {
  //   final response = await client.delete(Uri.parse('$baseUrl/locations/$id'));

  //   if (response.statusCode != 200 && response.statusCode != 204) {
  //     throw Exception('Failed to delete location');
  //   }
  // }

  // Future<bool> exists(String id) async {
  //   final response = await client.get(Uri.parse('$baseUrl/locations/$id'));

  //   if (response.statusCode == 200) {
  //     return true;
  //   } else if (response.statusCode == 404) {
  //     return false;
  //   } else {
  //     throw Exception('Failed to check if location exists');
  //   }
  // }
}
