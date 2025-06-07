import 'package:compaqi_test_app/domain/models/user.dart';

abstract class AuthRepository {
  Future<dynamic> login();
  Future<bool> isLoggedIn();
  Future<void> logout();
  Future<User> getLoggedUser();
}
