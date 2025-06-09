import 'package:compaqi_test_app/domain/models/models.dart' show Location;
import 'package:compaqi_test_app/domain/repositories/repositories.dart' show LocationRepository;

class GetSavedLocationsUseCase {
  final LocationRepository _locationRepository;

  const GetSavedLocationsUseCase({required LocationRepository locationRepository})
    : _locationRepository = locationRepository;

  Future<List<Location>?> execute() async {
    try {
      return await _locationRepository.getSavedLocations();
    } catch (e) {
      throw Exception('Failed to get saved locations: $e');
    }
  }
}
