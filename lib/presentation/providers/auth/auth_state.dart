import 'package:equatable/equatable.dart';

import 'package:compaqi_test_app/domain/models/models.dart' show User;

enum AuthStatus { idle, authenticated, unauthenticated, error }

class AuthState extends Equatable {
  final User? user;
  final AuthStatus status;

  const AuthState({this.user, this.status = AuthStatus.idle});

  factory AuthState.initial() => AuthState(user: null);

  @override
  List<Object?> get props => [user];

  AuthState copyWith({User? user, AuthStatus? status}) {
    return AuthState(user: user ?? this.user, status: status ?? this.status);
  }
}
