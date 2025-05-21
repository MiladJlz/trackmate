import 'package:fpdart/fpdart.dart';
import 'package:trackmate/core/common/domain/entities/user_entity.dart';
import 'package:trackmate/core/error/failures.dart';
import 'package:trackmate/core/usecase/usecase.dart';
import 'package:trackmate/features/auth/domain/repositories/auth_repository.dart';

class GetBiometric implements UseCase<bool, NoParams> {
  final AuthRepository authRepository;

  GetBiometric({required this.authRepository});
  @override
  Future<Either<Failure, bool>> call(params) async {
    return authRepository.getBiometricState();
  }
}
