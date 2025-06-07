import 'package:flutter_appauth/flutter_appauth.dart';

import 'package:compaqi_test_app/infrastructure/utils/environment.dart';

class GoogleAppAuth {
  Future<AuthorizationTokenResponse> authenticate() async {
    try {
      final FlutterAppAuth appAuth = FlutterAppAuth();
      final Map<String, String> oauthConfig = Environment.getOauthConfig();

      final AuthorizationTokenResponse result = await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          oauthConfig['clientId']!,
          oauthConfig['redirectUri']!,
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
