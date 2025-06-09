import 'package:compaqi_test_app/domain/repositories/repositories.dart' show LocationRepository;

class DeleteLocationUseCase {
  final LocationRepository _locationRepository;

  const DeleteLocationUseCase({required LocationRepository locationRepository})
    : _locationRepository = locationRepository;

  Future<void> execute(String id) async {
    try {
      await _locationRepository.deleteLocation(id);
    } catch (e) {
      throw Exception('Failed to delete location: $e');
    }
  }
}
