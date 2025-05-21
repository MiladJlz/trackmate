import 'package:flutter/material.dart';
import 'package:trackmate/core/common/domain/entities/user_entity.dart';

@immutable
sealed class AppUserState {}

final class AppUserInitial extends AppUserState {}

final class AppUserLoggedIn extends AppUserState {
  final UserEntity user;

  AppUserLoggedIn({required this.user});
}

final class AppUserNotFound extends AppUserState {}

