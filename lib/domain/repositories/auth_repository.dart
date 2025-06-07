abstract class AuthRepository {
  Future<dynamic> login();
  Future<bool> isLoggedIn();
}
