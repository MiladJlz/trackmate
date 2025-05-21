import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackmate/core/usecase/usecase.dart';
import 'package:trackmate/features/social/domain/usecases/social_follow_user.dart';
import 'package:trackmate/features/social/domain/usecases/social_get_followers.dart';
import 'package:trackmate/features/social/domain/usecases/social_get_followings.dart';
import 'package:trackmate/features/social/domain/usecases/social_get_followings_location.dart';
import 'package:trackmate/features/social/domain/usecases/social_search_user.dart';
import 'package:trackmate/features/social/domain/usecases/social_unfollow_user.dart';
import 'package:trackmate/features/social/presentation/bloc/social_event.dart';
import 'package:trackmate/features/social/presentation/bloc/social_state.dart';

import '../../domain/usecases/social_update_location.dart';

class SocialBloc extends Bloc<SocialEvent, SocialState> {
  SocialBloc({
    required SocialUserSearch searchUser,
    required SocialUserFollow followUser,
    required SocialUserUnfollow unfollowUser,
    required SocialUserGetFollowers getFollowers,
    required SocialUserGetFollowings getFollowings,
    required SocialGetFollowingsLocation getFollowingsLocation,
    required SocialUserUpdateLocation updateLocation,
  }) : _followUser = followUser,
       _searchUser = searchUser,
       _unfollowUser = unfollowUser,
       _getFollowers = getFollowers,
       _getFollowings = getFollowings,
       _getFollowingsLocation = getFollowingsLocation,
       _updateLocation = updateLocation,
       super(SocialInitial()) {
    on<SearchUserEvent>(_onSearchUser);
    on<FollowUserEvent>(_onFollowUser);
    on<UnfollowUserEvent>(_onUnfollowUser);
    on<GetFollowersEvent>(_onGetFollowers);
    on<GetFollowingsEvent>(_onGetFollowings);
    on<GetFollowingsLocationEvent>(_onGetFollowingsLocation);
    on<UpdateLocationEvent>(_onUpdateLocation);
  }

  final SocialUserFollow _followUser;
  final SocialUserGetFollowers _getFollowers;
  final SocialUserGetFollowings _getFollowings;
  final SocialUserSearch _searchUser;
  final SocialUserUnfollow _unfollowUser;
  final SocialGetFollowingsLocation _getFollowingsLocation;
  final SocialUserUpdateLocation _updateLocation;

  Future<void> _onSearchUser(
    SearchUserEvent event,
    Emitter<SocialState> emit,
  ) async {
    emit(SocialLoading());

    final result = await _searchUser(
      SearchUserParams(username: event.username),
    );
    final followings = await _getFollowings(NoParams());

    result.fold(
      (failure) => emit(SocialError(message: failure.message)),
      (users) => emit(
        SocialLoaded(
          users: users,
          followings: followings.fold(
            (failure) => [],
            (followings) => followings,
          ),
        ),
      ),
    );
  }

  Future<void> _onFollowUser(
    FollowUserEvent event,
    Emitter<SocialState> emit,
  ) async {
    final result = await _followUser(FollowUserParams(userId: event.userId));
    result.fold(
      (failure) => emit(FollowError(message: failure.message)),
      (_) => emit(FollowSuccess(message: 'کاربر با موفقیت فالو شد')),
    );
  }

  Future<void> _onUnfollowUser(
    UnfollowUserEvent event,
    Emitter<SocialState> emit,
  ) async {
    final result = await _unfollowUser(
      UnfollowUserParams(userId: event.userId),
    );
    result.fold(
      (failure) => emit(UnfollowError(message: failure.message)),
      (_) => emit(UnfollowSuccess(message: 'کاربر با موفقیت آنفالو شد')),
    );
  }

  Future<void> _onGetFollowers(
    GetFollowersEvent event,
    Emitter<SocialState> emit,
  ) async {
    final result = await _getFollowers(NoParams());
    result.fold(
      (failure) => emit(GetFollowersError(message: failure.message)),
      (followers) => emit(GetFollowersSuccess(followers: followers)),
    );
  }

  Future<void> _onGetFollowings(
    GetFollowingsEvent event,
    Emitter<SocialState> emit,
  ) async {
    final result = await _getFollowings(NoParams());
    result.fold(
      (failure) {
        emit(GetFollowingsError(message: failure.message));
      },
      (followings) {
        emit(GetFollowingsSuccess(followings: followings));
      },
    );
  }

  Future<void> _onGetFollowingsLocation(
    GetFollowingsLocationEvent event,
    Emitter<SocialState> emit,
  ) async {
    final result = await _getFollowingsLocation(NoParams());

    result.fold(
      (failure) => emit(GetFollowingsLocationError(message: failure.message)),
      (stream) async {
        return await emit.forEach(
          stream,
          onData: (users) => GetFollowingsLocationSuccess(followings: users),
          onError:
              (error, _) =>
                  GetFollowingsLocationError(message: error.toString()),
        );
      },
    );

 
  }

  Future<void> _onUpdateLocation(
    UpdateLocationEvent event,
    Emitter<SocialState> emit,
  ) async {
    final result = await _updateLocation(
      UpdateUserLocationParams(location: event.location),
    );
    result.fold((l) => UpdateLocationError(message: l.message), (r) {});
  }
}
