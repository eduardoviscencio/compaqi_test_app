import 'package:flutter/material.dart';

import 'package:compaqi_test_app/application/use_cases/use_cases.dart'
    show LoginUseCase, LogoutUseCase;
import 'package:compaqi_test_app/presentation/providers/auth/auth_state.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthState _state = AuthState.initial();

  AuthProvider({required LoginUseCase loginUseCase, required LogoutUseCase logoutUseCase})
    : _loginUseCase = loginUseCase,
      _logoutUseCase = logoutUseCase;

  AuthState get state => _state;

  Future<void> login() async {
    try {
      _state = _state.copyWith(status: AuthStatus.idle);
      notifyListeners();

      final user = await _loginUseCase.execute();

      _state = _state.copyWith(user: user, status: AuthStatus.authenticated);
    } catch (e) {
      _state = _state.copyWith(status: AuthStatus.error);
    } finally {
      notifyListeners();
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      final isLoggedIn = await _loginUseCase.isLoggedIn();

      if (isLoggedIn) {
        final user = await _loginUseCase.getLoggedUser();
        _state = _state.copyWith(user: user, status: AuthStatus.authenticated);
      } else {
        _state = _state.copyWith(user: null, status: AuthStatus.unauthenticated);
      }

      notifyListeners();

      return isLoggedIn;
    } catch (e) {
      _state = _state.copyWith(status: AuthStatus.error);
      notifyListeners();

      return false;
    }
  }

  Future<void> logout() async {
    try {
      _state = _state.copyWith(status: AuthStatus.idle);
      notifyListeners();

      await _logoutUseCase.execute();
      _state = _state.copyWith(user: null, status: AuthStatus.unauthenticated);
    } catch (e) {
      _state = _state.copyWith(status: AuthStatus.error);
    } finally {
      notifyListeners();
    }
  }
}
