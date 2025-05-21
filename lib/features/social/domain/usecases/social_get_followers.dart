import 'package:fpdart/src/either.dart';
import 'package:trackmate/core/error/failures.dart';
import 'package:trackmate/core/usecase/usecase.dart';
import 'package:trackmate/features/social/domain/entities/social_entity.dart';
import 'package:trackmate/features/social/domain/repositories/social_repository.dart';

class SocialUserGetFollowers implements UseCase<List<String>, NoParams> {
  final SocialRepository repository;
  SocialUserGetFollowers({required this.repository});

  @override
  Future<Either<Failure, List<String>>> call(Params) async {
    return await repository.getFollowers();
  }
}
