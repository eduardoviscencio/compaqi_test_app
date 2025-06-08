import 'package:http/http.dart' as http;

abstract class LocationDataSource {
  Future<http.Response> fetchLocations();
  // Future<void> postLocation(Map<String, dynamic> location);
  // Future<void> removeLocation(String id);
  // Future<int> exists(String id);
}
