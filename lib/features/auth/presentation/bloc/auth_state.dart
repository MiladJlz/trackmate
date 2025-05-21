import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:trackmate/core/common/domain/entities/user_entity.dart';

@immutable
sealed class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthFailure extends AuthState {
  final String message;
  AuthFailure({required this.message});
  @override
  List<Object> get props => [message];
}

final class AuthSuccess extends AuthState {
  final UserEntity user;
  AuthSuccess({required this.user});
  @override
  List<Object> get props => [user];
}
final class AuthBiometricSuccess extends AuthState {
  final bool isBiometricEnabled;
  AuthBiometricSuccess({required this.isBiometricEnabled});
  @override
  List<Object> get props => [isBiometricEnabled];
}

final class AuthBiometricFailure extends AuthState {
  final String message;
  AuthBiometricFailure({required this.message});
  @override
  List<Object> get props => [message];
}

final class AuthBiometricLoading extends AuthState {}
