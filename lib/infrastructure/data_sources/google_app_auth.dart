import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_appauth/flutter_appauth.dart';

import 'package:compaqi_test_app/infrastructure/config/config.dart' show Environment, OauthConfig;
import 'package:compaqi_test_app/infrastructure/services/services.dart' show TokenService;

class GoogleAppAuth {
  final FlutterAppAuth _appAuth = FlutterAppAuth();

  Future<AuthorizationTokenResponse> authenticate() async {
    final OauthConfig oauthConfig = Environment.getOauthConfig();

    try {
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
      print('Authentication error: $e');
      throw Exception('Authentication failed: $e');
    }
  }

  Future<bool> isAuthenticated() async {
    try {
      final token = await TokenService.getValidAccessToken();

      return token != null;
    } catch (e) {
      throw Exception('Failed to check authentication status: $e');
    }
  }

  Future<String> getIdToken() async {
    try {
      final idToken = await TokenService.getIdToken();

      if (idToken == null || idToken.isEmpty) {
        throw Exception('ID Token not found');
      }

      return idToken;
    } catch (e) {
      throw Exception('Failed to retrieve ID Token: $e');
    }
  }

  Future<void> logout() async {
    try {
      final token = await TokenService.getAccessToken();

      if (token != null && token.isNotEmpty) {
        await http.post(
          Uri.parse('https://oauth2.googleapis.com/revoke?token=$token'),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        );
      }

      await TokenService.logout();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }
}
