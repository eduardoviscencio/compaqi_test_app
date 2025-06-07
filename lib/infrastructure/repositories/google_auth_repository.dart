import 'package:compaqi_test_app/domain/models/models.dart' show User;
import 'package:compaqi_test_app/domain/repositories/repositories.dart' show AuthRepository;
import 'package:compaqi_test_app/infrastructure/data_sources/google_app_auth.dart'
    show GoogleAppAuth;
import 'package:compaqi_test_app/infrastructure/dtos/dtos.dart' show GoogleAuthDTO;
import 'package:compaqi_test_app/infrastructure/utils/utils.dart' show parseIdToken;

class GoogleAuthRepository implements AuthRepository {
  final GoogleAppAuth _googleAppAuth;

  GoogleAuthRepository({required GoogleAppAuth dataSource}) : _googleAppAuth = dataSource;

  @override
  Future<User> login() async {
    try {
      final result = await _googleAppAuth.authenticate();
      final profile = parseIdToken(result.idToken!);

      final GoogleAuthDTO userDTO = GoogleAuthDTO.fromJson(profile);

      return userDTO.toDomain();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final isAuthenticated = await _googleAppAuth.isAuthenticated();

      return isAuthenticated;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<User> getLoggedUser() async {
    try {
      final idToken = await _googleAppAuth.getIdToken();
      final profile = parseIdToken(idToken);

      final GoogleAuthDTO userDTO = GoogleAuthDTO.fromJson(profile);

      return userDTO.toDomain();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _googleAppAuth.logout();
    } catch (e) {
      rethrow;
    }
  }
}
