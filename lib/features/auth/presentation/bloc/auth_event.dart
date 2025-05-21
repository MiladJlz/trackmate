import 'package:flutter/material.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignUp extends AuthEvent {
  final String email;
  final String password;
  final String username;
  AuthSignUp({
    required this.email,
    required this.password,
    required this.username,
  });
}

final class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  AuthLogin({required this.email, required this.password});
}

final class AuthLogout extends AuthEvent {}

final class AuthCurrentUser extends AuthEvent {}

final class AuthSaveBiometric extends AuthEvent {
  final bool isBiometricEnabled;
  AuthSaveBiometric({required this.isBiometricEnabled});
}


final class AuthToggleBiometric extends AuthEvent {
  final bool isEnabled;
  AuthToggleBiometric({required this.isEnabled});
}

final class AuthCheckBiometric extends AuthEvent {}
