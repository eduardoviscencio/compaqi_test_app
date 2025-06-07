import 'package:compaqi_test_app/domain/repositories/repositories.dart' show AuthRepository;

class LogoutUseCase {
  final AuthRepository _authRepository;

  LogoutUseCase({required AuthRepository authRepository}) : _authRepository = authRepository;

  Future<void> execute() async {
    try {
      await _authRepository.logout();
    } catch (e) {
      rethrow;
    }
  }
}
