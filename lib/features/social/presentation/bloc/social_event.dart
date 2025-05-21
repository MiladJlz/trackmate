import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class SocialEvent extends Equatable {
  const SocialEvent();

  @override
  List<Object> get props => [];
}

class SearchUserEvent extends SocialEvent {
  final String username;

  const SearchUserEvent({required this.username});

  @override
  List<Object> get props => [username];
}

class FollowUserEvent extends SocialEvent {
  final String userId;

  const FollowUserEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class UnfollowUserEvent extends SocialEvent {
  final String userId;

  const UnfollowUserEvent({required this.userId});
}

class GetFollowersEvent extends SocialEvent {
  const GetFollowersEvent();
}

class GetFollowingsEvent extends SocialEvent {
  const GetFollowingsEvent();
}

class GetFollowingsLocationEvent extends SocialEvent {
  const GetFollowingsLocationEvent();
}

class UpdateLocationEvent extends SocialEvent {
  final GeoPoint location;
  const UpdateLocationEvent({required this.location});
}
