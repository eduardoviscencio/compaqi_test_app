import 'package:http/http.dart' as http;

import 'package:compaqi_test_app/infrastructure/dtos/dtos.dart' show LocationDTO;

abstract class LocationDataSource {
  Future<http.Response> fetchLocations();
  Future<http.Response> saveLocation(LocationDTO location);
  Future<http.Response> deleteLocation(String id);
}
