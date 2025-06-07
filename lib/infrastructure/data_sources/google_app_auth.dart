import 'package:flutter_appauth/flutter_appauth.dart';

class GoogleAppAuth {
  Future<AuthorizationTokenResponse> authenticate() async {
    try {
      final FlutterAppAuth appAuth = FlutterAppAuth();

      final AuthorizationTokenResponse result = await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          '699390330628-73n9v1l6r6ihv06uh2rum0hgv75ad553.apps.googleusercontent.com',
          'com.eduardoviscencio.compaqiTestApp:/oauthredirect',
          discoveryUrl: 'https://accounts.google.com/.well-known/openid-configuration',
          scopes: ['openid', 'profile', 'email'],
        ),
      );

      return result;
    } catch (e) {
      rethrow;
    }
  }
}
