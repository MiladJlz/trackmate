import 'package:fpdart/fpdart.dart';
import 'package:trackmate/core/error/failures.dart';
import 'package:trackmate/core/usecase/usecase.dart';
import 'package:trackmate/features/social/domain/repositories/social_repository.dart';

class SocialUserUnfollow implements UseCase<void, UnfollowUserParams> {
  final SocialRepository repository;

  SocialUserUnfollow({required this.repository});

  @override
  Future<Either<Failure, void>> call(params) async {
    return await repository.unfollowUser(params.userId);
  }
}

class UnfollowUserParams {
  final String userId;
  UnfollowUserParams({required this.userId});
}
