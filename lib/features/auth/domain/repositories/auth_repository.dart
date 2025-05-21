import 'package:fpdart/fpdart.dart';
import 'package:trackmate/core/common/domain/entities/user_entity.dart';
import 'package:trackmate/core/error/failures.dart';
import 'package:trackmate/features/auth/domain/usecases/save_biometric.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, UserEntity>> signupUser(String email, String password, String username);

  Future<Either<Failure, UserEntity>> loginUser(String email, String password);

  Future<Failure?> logoutUser();
  Future<Either<Failure, UserEntity>> currentUser();
  Future<Either<Failure, bool>> saveBiometricState(SaveBiometricParam param);
  Future<Either<Failure, bool>> getBiometricState();
}
