import 'package:local_auth/local_auth.dart';

class BiometricsService {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> isBiometricsAvailable() async {
    try {
      return await _auth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> authenticateWithBiometrics() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Please authenticate to proceed',
        options: const AuthenticationOptions(useErrorDialogs: true, stickyAuth: true),
      );
    } catch (e) {
      return false;
    }
  }
}
