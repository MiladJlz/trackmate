import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/social_repository.dart';

class SocialUserUpdateLocation
    implements UseCase<void, UpdateUserLocationParams> {
  final SocialRepository repository;

  SocialUserUpdateLocation({required this.repository});

  @override
  Future<Either<Failure, void>> call(params) async {
    return await repository.updateUserLocation(params.location);
  }
}

class UpdateUserLocationParams {
  final GeoPoint location;
  UpdateUserLocationParams({required this.location});
}
