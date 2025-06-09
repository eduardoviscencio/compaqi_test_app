import 'package:compaqi_test_app/domain/models/models.dart' show Location;
import 'package:compaqi_test_app/domain/repositories/repositories.dart' show LocationRepository;

class AddLocationUseCase {
  final LocationRepository _locationRepository;

  const AddLocationUseCase({required LocationRepository locationRepository})
    : _locationRepository = locationRepository;

  Future<Location?> execute(Location location) async {
    try {
      return await _locationRepository.addLocation(location);
    } catch (e) {
      rethrow;
    }
  }
}
