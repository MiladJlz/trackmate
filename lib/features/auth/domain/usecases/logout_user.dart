import 'package:fpdart/fpdart.dart';
import 'package:trackmate/core/error/failures.dart';
import 'package:trackmate/core/usecase/usecase.dart';
import 'package:trackmate/features/auth/domain/repositories/auth_repository.dart';

class UserLogout implements FutureUseCase<Failure?, NoParams> {
  final AuthRepository authRepository;
  UserLogout({required this.authRepository});

  @override
  Future<Failure?> call(params) {
    return authRepository.logoutUser();
  }
}
