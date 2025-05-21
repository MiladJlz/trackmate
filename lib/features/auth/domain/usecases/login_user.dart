import 'package:fpdart/fpdart.dart';
import 'package:trackmate/core/common/domain/entities/user_entity.dart';
import 'package:trackmate/core/error/failures.dart';
import 'package:trackmate/core/usecase/usecase.dart';
import 'package:trackmate/features/auth/domain/repositories/auth_repository.dart';

class UserLogin implements UseCase<UserEntity, LoginParams> {
  final AuthRepository authRepository;
  UserLogin({required this.authRepository});

  @override
  Future<Either<Failure, UserEntity>> call(params) {
    return authRepository.loginUser(params.email, params.password);
  }
}

class LoginParams {
  final String email;
  final String password;
  LoginParams({required this.email, required this.password});
}
