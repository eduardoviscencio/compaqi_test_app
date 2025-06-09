abstract class BiometricsRepository {
  Future<bool> isBiometricsAvailable();
  Future<bool> authenticateWithBiometrics();
}
