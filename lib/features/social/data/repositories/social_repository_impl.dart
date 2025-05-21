import 'package:cloud_firestore_platform_interface/src/geo_point.dart';
import 'package:fpdart/fpdart.dart';
import 'package:trackmate/core/common/domain/entities/user_entity.dart';
import 'package:trackmate/core/error/exceptions.dart';
import 'package:trackmate/core/error/failures.dart';
import 'package:trackmate/features/social/data/datasources/social_remote_data_source.dart';
import 'package:trackmate/features/social/domain/repositories/social_repository.dart';

class SocialRepositoryImpl implements SocialRepository {
  final SocialRemoteDataSource remoteDataSource;
  SocialRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<UserEntity>>> searchUser(String username) async {
    try {
      final users = await remoteDataSource.searchUser(username);
      return right(users);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> followUser(String userId) async {
    try {
      await remoteDataSource.followUser(userId);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> unfollowUser(String userId) async {
    try {
      await remoteDataSource.unfollowUser(userId);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getFollowers() async {
    try {
      final followers = await remoteDataSource.getFollowers();
      return right(followers);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getFollowing() async {
    try {
      final following = await remoteDataSource.getFollowings();
      return right(following);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Stream<List<UserEntity>>>>
  getFollowingsLocation() async {
    try {
      final stream = remoteDataSource.getFollowingsLocation();
      return right(stream);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserLocation(GeoPoint location) async {
    try {
      await remoteDataSource.updateLocation(location);
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
