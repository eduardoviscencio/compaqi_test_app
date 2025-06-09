import 'package:http/http.dart' as http;

import 'package:compaqi_test_app/domain/models/models.dart';

abstract class LocationDataSource {
  Future<http.Response> fetchLocations();
  Future<http.Response> saveLocation(Location location);
  Future<http.Response> deleteLocation(String id);
}
