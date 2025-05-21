import 'package:fpdart/fpdart.dart';
import 'package:trackmate/core/common/domain/entities/user_entity.dart';
import 'package:trackmate/core/error/failures.dart';
import 'package:trackmate/core/usecase/usecase.dart';
import 'package:trackmate/features/social/domain/repositories/social_repository.dart';

class SocialGetFollowingsLocation
    implements UseCase<Stream<List<UserEntity>>, NoParams> {
  final SocialRepository repository;

  SocialGetFollowingsLocation({required this.repository});

  @override
  Future<Either<Failure, Stream<List<UserEntity>>>> call(params) async {
    return repository.getFollowingsLocation();
  }
}
