import 'package:equatable/equatable.dart';
import 'package:trackmate/core/common/domain/entities/user_entity.dart';

abstract class SocialState extends Equatable {
  const SocialState();

  @override
  List<Object> get props => [];
}

class SocialInitial extends SocialState {}

class SocialLoading extends SocialState {}

class SocialLoaded extends SocialState {
  final List<UserEntity> users;
  final List<String> followings;
  const SocialLoaded({required this.users, required this.followings});

  @override
  List<Object> get props => [users, followings];
}

class SocialError extends SocialState {
  final String message;

  const SocialError({required this.message});

  @override
  List<Object> get props => [message];
}

class FollowSuccess extends SocialState {
  final String message;

  const FollowSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class FollowError extends SocialState {
  final String message;

  const FollowError({required this.message});

  @override
  List<Object> get props => [message];
}

class UnfollowSuccess extends SocialState {
  final String message;

  const UnfollowSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class UnfollowError extends SocialState {
  final String message;

  const UnfollowError({required this.message});

  @override
  List<Object> get props => [message];
}

class GetFollowersSuccess extends SocialState {
  final List<String> followers;

  const GetFollowersSuccess({required this.followers});

  @override
  List<Object> get props => [followers];
}

class GetFollowersError extends SocialState {
  final String message;

  const GetFollowersError({required this.message});

  @override
  List<Object> get props => [message];
}

class GetFollowingsSuccess extends SocialState {
  final List<String> followings;

  const GetFollowingsSuccess({required this.followings});

  @override
  List<Object> get props => [followings];
}

class GetFollowingsError extends SocialState {
  final String message;

  const GetFollowingsError({required this.message});

  @override
  List<Object> get props => [message];
}

class GetFollowingsLocationSuccess extends SocialState {
  final List<UserEntity> followings;

  const GetFollowingsLocationSuccess({required this.followings});

  @override
  List<Object> get props => [followings];
}

class GetFollowingsLocationError extends SocialState {
  final String message;

  const GetFollowingsLocationError({required this.message});

  @override
  List<Object> get props => [message];
}

class UpdateLocationError extends SocialState {
  final String message;

  const UpdateLocationError({required this.message});

  @override
  List<Object> get props => [message];
}
