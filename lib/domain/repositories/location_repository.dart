import 'package:compaqi_test_app/domain/models/models.dart' show Location;

abstract class LocationRepository {
  Future<List<Location>?> getSavedLocations();
  // Future<void> saveLocation(String location);
  // Future<void> deleteLocation();
  // Future<bool> isLocationSaved();
}
