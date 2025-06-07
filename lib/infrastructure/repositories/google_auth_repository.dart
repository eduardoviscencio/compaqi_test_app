import 'package:compaqi_test_app/domain/models/models.dart' show User;
import 'package:compaqi_test_app/domain/repositories/repositories.dart' show AuthRepository;
import 'package:compaqi_test_app/infrastructure/data_sources/google_app_auth.dart'
    show GoogleAppAuth;
import 'package:compaqi_test_app/infrastructure/dtos/dtos.dart' show UserDTO;
import 'package:compaqi_test_app/infrastructure/utils/utils.dart' show parseIdToken;

class GoogleAuthRepository implements AuthRepository {
  final GoogleAppAuth _googleAppAuth;

  GoogleAuthRepository({required GoogleAppAuth dataSource}) : _googleAppAuth = dataSource;

  @override
  Future<User> login() async {
    try {
      final result = await _googleAppAuth.authenticate();
      final profile = parseIdToken(result.idToken!);

      final UserDTO userDTO = UserDTO.fromJson(profile);

      return userDTO.toDomain();
    } catch (e) {
      rethrow;
    }
  }
}
