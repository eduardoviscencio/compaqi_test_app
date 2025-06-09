import 'package:compaqi_test_app/infrastructure/services/services.dart' show BiometricsService;

class LocalAuthDataSource {
  LocalAuthDataSource();

  Future<bool> isBiometricsAvailable() async {
    try {
      return await BiometricsService.isBiometricsAvailable();
    } catch (e) {
      return false;
    }
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      return await BiometricsService.authenticateWithBiometrics();
    } catch (e) {
      return false;
    }
  }
}
