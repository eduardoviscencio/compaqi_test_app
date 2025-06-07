import 'package:flutter_appauth/flutter_appauth.dart';

import 'package:compaqi_test_app/infrastructure/config/config.dart' show Environment, OauthConfig;
import 'package:compaqi_test_app/infrastructure/services/services.dart' show TokenService;

class GoogleAppAuth {
  final FlutterAppAuth _appAuth = FlutterAppAuth();

  Future<AuthorizationTokenResponse> authenticate() async {
    try {
      final OauthConfig oauthConfig = Environment.getOauthConfig();

      final AuthorizationTokenResponse result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          oauthConfig.clientId,
          oauthConfig.redirectUri,
          discoveryUrl: 'https://accounts.google.com/.well-known/openid-configuration',
          scopes: ['openid', 'profile', 'email'],
        ),
      );

      await TokenService.saveTokens(
        result.accessToken!,
        result.refreshToken!,
        result.idToken ?? '',
        result.accessTokenExpirationDateTime,
      );

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isAuthenticated() async {
    try {
      final token = await TokenService.getValidAccessToken();

      return token != null;
    } catch (_) {
      return false;
    }
  }
}
