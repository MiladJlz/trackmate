import 'package:fpdart/fpdart.dart';
import 'package:trackmate/core/error/failures.dart';
import 'package:trackmate/core/usecase/usecase.dart';
import 'package:trackmate/features/auth/domain/repositories/auth_repository.dart';

class SaveBiometric implements UseCase<bool, SaveBiometricParam> {
  final AuthRepository authRepository;

  SaveBiometric({required this.authRepository});
  @override
  Future<Either<Failure, bool>> call(params) async {
    return authRepository.saveBiometricState(params);
  }
}
class SaveBiometricParam {
  final bool isBiometricEnabled;
  SaveBiometricParam({required this.isBiometricEnabled});
}

