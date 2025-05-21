import 'package:fpdart/fpdart.dart';
import 'package:trackmate/core/common/domain/entities/user_entity.dart';
import 'package:trackmate/core/error/failures.dart';
import 'package:trackmate/core/usecase/usecase.dart';
import 'package:trackmate/features/social/domain/repositories/social_repository.dart';

class SocialUserSearch implements UseCase<List<UserEntity>, SearchUserParams> {
  final SocialRepository repository;
  SocialUserSearch({required this.repository});

  @override
  Future<Either<Failure, List<UserEntity>>> call(params) async {
    return repository.searchUser(params.username);
  }
}

class SearchUserParams {
  final String username;
  SearchUserParams({required this.username});
}
