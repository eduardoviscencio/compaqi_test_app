import 'dart:io';

class Environment {
  static String get mapsApiKey =>
      const String.fromEnvironment('GOOGLE_MAPS_API_KEY', defaultValue: 'api_key_not_found');

  static Map<String, String> get _iosOAuth => const {
    'clientId': String.fromEnvironment('IOS_OAUTH_CLIENT_ID', defaultValue: 'client_id_not_found'),
    'redirectUri': String.fromEnvironment(
      'IOS_OAUTH_REDIRECT_URI',
      defaultValue: 'redirect_uri_not_found',
    ),
  };

  static Map<String, String> get _androidOAuth => const {
    'clientId': String.fromEnvironment(
      'ANDROID_OAUTH_CLIENT_ID',
      defaultValue: 'client_id_not_found',
    ),
    'redirectUri': String.fromEnvironment(
      'ANDROID_OAUTH_REDIRECT_URI',
      defaultValue: 'redirect_uri_not_found',
    ),
  };

  static Map<String, String> getOauthConfig() {
    if (Platform.isIOS) {
      return _iosOAuth;
    } else if (Platform.isAndroid) {
      return _androidOAuth;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
