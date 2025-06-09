import 'package:compaqi_test_app/domain/models/models.dart' show Location;

abstract class LocationRepository {
  Future<List<Location>?> getSavedLocations();
  Future<Location?> addLocation(Location location);
  Future<void> deleteLocation(String id);
}
