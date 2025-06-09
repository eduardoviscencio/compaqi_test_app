import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:compaqi_test_app/infrastructure/dtos/dtos.dart' show LocationDTO;
import 'package:compaqi_test_app/infrastructure/config/config.dart' show Environment;
import 'package:compaqi_test_app/infrastructure/data_sources/data_sources.dart'
    show LocationDataSource;
import 'package:compaqi_test_app/infrastructure/services/services.dart' show TokenService;

class LocationRemoteDataSource implements LocationDataSource {
  final String _baseUrl = Environment.apiUrl;

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

  @override
  Future<http.Response> saveLocation(LocationDTO location) async {
    try {
      final Uri uri = Uri.https(_baseUrl, '/api/locations');

      final token = await TokenService.getIdToken();

      if (token == null || token.isEmpty) {
        throw Exception('Access token is not available');
      }

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode(location.toJson()),
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<http.Response> deleteLocation(String id) async {
    try {
      final Uri uri = Uri.https(_baseUrl, '/api/locations/$id');

      final token = await TokenService.getIdToken();

      if (token == null || token.isEmpty) {
        throw Exception('Access token is not available');
      }

      final response = await http.delete(
        uri,
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
