import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:compaqi_test_app/infrastructure/config/config.dart' show Environment, OauthConfig;

class TokenService {
  static final FlutterAppAuth _auth = FlutterAppAuth();
  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static final OauthConfig _config = Environment.getOauthConfig();

  static Future<void> saveTokens(
    String accessToken,
    String refreshToken,
    String idToken,
    DateTime? accessTokenExpirationDateTime,
  ) async {
    await _storage.write(key: 'accessToken', value: accessToken);
    await _storage.write(key: 'refreshToken', value: refreshToken);
    await _storage.write(key: 'idToken', value: idToken);
    await _storage.write(
      key: 'accessTokenExpiry',
      value: accessTokenExpirationDateTime?.toIso8601String(),
    );
  }

  static Future<bool> isAccessTokenExpired() async {
    final expiryRaw = await _storage.read(key: 'accessTokenExpiry');
    if (expiryRaw == null) return true;

    final expiry = DateTime.tryParse(expiryRaw);
    if (expiry == null) return true;

    return DateTime.now().isAfter(expiry);
  }

  static Future<bool> refreshTokens() async {
    final refreshToken = await _storage.read(key: 'refreshToken');
    if (refreshToken == null) return false;

    try {
      final TokenResponse result = await _auth.token(
        TokenRequest(
          _config.clientId,
          _config.redirectUri,
          refreshToken: refreshToken,
          discoveryUrl: _config.discoveryUrl,
          scopes: _config.scopes,
        ),
      );

      if (result.accessToken == null || result.refreshToken == null || result.idToken == null) {
        return false;
      }

      await saveTokens(
        result.accessToken!,
        result.refreshToken!,
        result.idToken ?? '',
        result.accessTokenExpirationDateTime,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<String?> getValidAccessToken() async {
    final isExpired = await isAccessTokenExpired();

    if (isExpired) {
      final success = await refreshTokens();
      if (!success) return null;
    }

    return await _storage.read(key: 'accessToken');
  }

  static Future<void> logout() async {
    await _storage.deleteAll();
  }

  static Future<bool> isLoggedIn() async {
    final token = await getValidAccessToken();

    return token != null;
  }
}
