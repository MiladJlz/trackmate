import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/src/either.dart';
import 'package:trackmate/core/common/data/models/user_model.dart';
import 'package:trackmate/core/common/domain/entities/user_entity.dart';
import 'package:trackmate/core/error/exceptions.dart';
import 'package:trackmate/core/error/failures.dart';
import 'package:trackmate/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:trackmate/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:trackmate/features/auth/domain/repositories/auth_repository.dart';
import 'package:trackmate/features/auth/domain/usecases/save_biometric.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;
  final FirebaseFirestore firestore;
  AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.firestore,
    required this.authLocalDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> loginUser(
    String email,
    String password,
  ) async {
    try {
      final user = await authRemoteDataSource.signIn(email, password);
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Failure?> logoutUser() async {
    try {
      await authRemoteDataSource.logout();
      return null;
    } on ServerException catch (e) {
      return Failure(e.message);
    }
  }

  @override
  Future<Either<Failure, UserEntity>> currentUser() async {
    final user = await authRemoteDataSource.currentUser;
    if (user == null) {
      return left(Failure("User not logged in!"));
    }
    return right(user);
  }

  @override
  Future<Either<Failure, UserEntity>> signupUser(
    String email,
    String password,
    String username,
  ) async {
    try {
      return await firestore.runTransaction((transaction) async {
        UserModel user = await authRemoteDataSource.signUp(email, password);
        user = user.copyWith(username: username);
        transaction.set(
          firestore.collection("users").doc(user.id),
          user.toJson(),
        );

        return right(user);
      });
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
  
  @override
  Future<Either<Failure, bool>> getBiometricState() async {
    try {
      final isBiometricEnabled = await authLocalDataSource.getBiometricState();
      return right(isBiometricEnabled);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
  
  @override
  Future<Either<Failure, bool>> saveBiometricState(SaveBiometricParam biometricParam) async {
      try {
      await authLocalDataSource.saveBiometricState(biometricParam.isBiometricEnabled);
      return right(biometricParam.isBiometricEnabled);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
