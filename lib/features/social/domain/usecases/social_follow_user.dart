import 'package:fpdart/fpdart.dart';
import 'package:trackmate/core/error/failures.dart';
import 'package:trackmate/core/usecase/usecase.dart';
import 'package:trackmate/features/social/domain/repositories/social_repository.dart';

class SocialUserFollow implements UseCase<void, FollowUserParams> {
  final SocialRepository repository;

  SocialUserFollow({required this.repository});

  @override
  Future<Either<Failure, void>> call(params) async {
    return await repository.followUser(params.userId);
  }
}

class FollowUserParams {
  final String userId;
  FollowUserParams({required this.userId});
}
