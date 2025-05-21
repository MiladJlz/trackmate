import 'package:fpdart/fpdart.dart';
import 'package:trackmate/core/common/domain/entities/user_entity.dart';
import 'package:trackmate/core/error/failures.dart';
import 'package:trackmate/core/usecase/usecase.dart';
import 'package:trackmate/features/auth/domain/repositories/auth_repository.dart';

class UserSignUp implements UseCase<UserEntity, SignUpParams> {
  final AuthRepository authRepository;
  UserSignUp({required this.authRepository});

  @override
  Future<Either<Failure, UserEntity>> call(params) {
    return authRepository.signupUser(params.email, params.password, params.username);
  }
}

class SignUpParams {
  final String email;
  final String password;
  final String username;
  SignUpParams({required this.email, required this.password, required this.username});
}
