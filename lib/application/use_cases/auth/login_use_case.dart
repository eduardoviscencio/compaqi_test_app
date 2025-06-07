import 'package:compaqi_test_app/domain/models/models.dart' show User;
import 'package:compaqi_test_app/domain/repositories/repositories.dart' show AuthRepository;

class LoginUseCase {
  final AuthRepository _authRepository;

  const LoginUseCase({required AuthRepository authRepository}) : _authRepository = authRepository;

  Future<User> execute() async {
    try {
      return await _authRepository.login();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      return await _authRepository.isLoggedIn();
    } catch (e) {
      return false;
    }
  }
}
