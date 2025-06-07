import 'package:flutter/material.dart';

import 'package:compaqi_test_app/application/use_cases/use_cases.dart' show LoginUseCase;
import 'package:compaqi_test_app/presentation/providers/auth/auth_state.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUseCase _loginUseCase;

  AuthState _state = AuthState.initial();

  AuthProvider({required LoginUseCase loginUseCase}) : _loginUseCase = loginUseCase;

  AuthState get state => _state;

  Future<void> login() async {
    _state = _state.copyWith(status: AuthStatus.idle);
    notifyListeners();

    try {
      final user = await _loginUseCase.execute();

      _state = _state.copyWith(user: user, status: AuthStatus.authenticated);
    } catch (e) {
      _state = _state.copyWith(status: AuthStatus.error);
    }

    notifyListeners();
  }
}
