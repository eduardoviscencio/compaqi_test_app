import 'dart:io';

import 'package:compaqi_test_app/infrastructure/config/config.dart' show OauthConfig;

class Environment {
  static const String apiUrl = String.fromEnvironment('API_URL', defaultValue: 'api_url_not_found');

  static String get mapsApiKey =>
      const String.fromEnvironment('GOOGLE_MAPS_API_KEY', defaultValue: 'api_key_not_found');

  static OauthConfig getOauthConfig() {
    if (Platform.isIOS) {
      return OauthConfig(
        clientId: const String.fromEnvironment(
          'IOS_OAUTH_CLIENT_ID',
          defaultValue: 'client_id_not_found',
        ),
        redirectUri: const String.fromEnvironment(
          'IOS_OAUTH_REDIRECT_URI',
          defaultValue: 'redirect_uri_not_found',
        ),
        discoveryUrl: 'https://accounts.google.com/.well-known/openid-configuration',
        scopes: ['openid', 'profile', 'email'],
      );
    }

    if (Platform.isAndroid) {
      return OauthConfig(
        clientId: const String.fromEnvironment(
          'ANDROID_OAUTH_CLIENT_ID',
          defaultValue: 'client_id_not_found',
        ),
        redirectUri: const String.fromEnvironment(
          'ANDROID_OAUTH_REDIRECT_URI',
          defaultValue: 'redirect_uri_not_found',
        ),
        discoveryUrl: 'https://accounts.google.com/.well-known/openid-configuration',
        scopes: ['openid', 'profile', 'email'],
      );
    }

    throw UnsupportedError('Unsupported platform');
  }
}
