import 'package:compaqi_test_app/domain/repositories/repositories.dart' show BiometricsRepository;

class BiometricsUseCase {
  final BiometricsRepository _biometricsRepository;

  BiometricsUseCase({required BiometricsRepository biometricsRepository})
    : _biometricsRepository = biometricsRepository;

  Future<bool> execute() async {
    try {
      return await _biometricsRepository.authenticateWithBiometrics();
    } catch (e) {
      return false;
    }
  }

  Future<bool> isBiometricsAvailable() async {
    try {
      return await _biometricsRepository.isBiometricsAvailable();
    } catch (e) {
      return false;
    }
  }
}
