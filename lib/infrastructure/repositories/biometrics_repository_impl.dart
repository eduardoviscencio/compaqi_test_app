import 'package:compaqi_test_app/domain/repositories/repositories.dart' show BiometricsRepository;
import 'package:compaqi_test_app/infrastructure/data_sources/data_sources.dart';

class BiometricsRepositoryImpl implements BiometricsRepository {
  final LocalAuthDataSource _localAuth;

  BiometricsRepositoryImpl({required LocalAuthDataSource localAuth}) : _localAuth = localAuth;

  @override
  Future<bool> isBiometricsAvailable() async {
    try {
      return await _localAuth.isBiometricsAvailable();
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> authenticateWithBiometrics() async {
    try {
      return await _localAuth.authenticateWithBiometrics();
    } catch (e) {
      return false;
    }
  }
}
