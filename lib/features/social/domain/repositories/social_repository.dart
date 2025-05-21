import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:trackmate/core/common/domain/entities/user_entity.dart';
import 'package:trackmate/core/error/failures.dart';

abstract interface class SocialRepository {
  Future<Either<Failure, List<UserEntity>>> searchUser(String username);
  Future<Either<Failure, void>> followUser(String userId);
  Future<Either<Failure, void>> unfollowUser(String userId);
  Future<Either<Failure, List<String>>> getFollowers();
  Future<Either<Failure, List<String>>> getFollowing();
  Future<Either<Failure, Stream<List<UserEntity>>>> getFollowingsLocation();
  Future<Either<Failure, void>> updateUserLocation(GeoPoint location);
}
