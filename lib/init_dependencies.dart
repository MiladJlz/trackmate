import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackmate/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:trackmate/core/secrets/app_secrets.dart';
import 'package:trackmate/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:trackmate/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:trackmate/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:trackmate/features/auth/domain/repositories/auth_repository.dart';
import 'package:trackmate/features/auth/domain/usecases/current_user.dart';
import 'package:trackmate/features/auth/domain/usecases/get_biometric.dart';
import 'package:trackmate/features/auth/domain/usecases/login_user.dart';
import 'package:trackmate/features/auth/domain/usecases/logout_user.dart';
import 'package:trackmate/features/auth/domain/usecases/save_biometric.dart';
import 'package:trackmate/features/auth/domain/usecases/signup_user.dart';
import 'package:trackmate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:trackmate/features/social/data/datasources/social_remote_data_source.dart';
import 'package:trackmate/features/social/data/repositories/social_repository_impl.dart';
import 'package:trackmate/features/social/domain/repositories/social_repository.dart';
import 'package:trackmate/features/social/domain/usecases/social_follow_user.dart';
import 'package:trackmate/features/social/domain/usecases/social_get_followers.dart';
import 'package:trackmate/features/social/domain/usecases/social_get_followings.dart';
import 'package:trackmate/features/social/domain/usecases/social_get_followings_location.dart';
import 'package:trackmate/features/social/domain/usecases/social_search_user.dart';
import 'package:trackmate/features/social/domain/usecases/social_unfollow_user.dart';
import 'package:trackmate/features/social/domain/usecases/social_update_location.dart';
import 'package:trackmate/features/social/presentation/bloc/social_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await AppSecrets.load();
  var appId = kIsWeb ? AppSecrets.webAppId : AppSecrets.androidAppId;
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: AppSecrets.webApiKey!,
      projectId: AppSecrets.projectId!,
      storageBucket: AppSecrets.storageBucket!,
      messagingSenderId: AppSecrets.messagingSenderId!,
      appId: appId!,
    ),
  );
  var prefs = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => FirebaseAuth.instance);
  serviceLocator.registerLazySingleton(() => FirebaseFirestore.instance);
  serviceLocator.registerLazySingleton(() => prefs);
  serviceLocator.registerLazySingleton(() => AppUserCubit());
  serviceLocator.registerLazySingleton(() => LocalAuthentication());
  await _initAuth();
  await _initSocial();
}

Future<void> _initAuth() async {
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        firebaseAuth: serviceLocator(),
        firestore: serviceLocator(),
      ),
    )
    ..registerFactory<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(
      prefs: serviceLocator(),
      ),
    )
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        authRemoteDataSource: serviceLocator(),
        firestore: serviceLocator(),
        authLocalDataSource: serviceLocator(),
      ),
    )
    ..registerFactory(() => UserSignUp(authRepository: serviceLocator()))
    ..registerFactory(() => UserLogin(authRepository: serviceLocator()))
    ..registerFactory(() => CurrentUser(authRepository: serviceLocator()))
    ..registerFactory(() => UserLogout(authRepository: serviceLocator()))
    ..registerFactory(() => SaveBiometric(authRepository: serviceLocator()))
    ..registerFactory(() => GetBiometric(authRepository: serviceLocator()))
    ..registerLazySingleton(
      () => AuthBloc(
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
        signUpUser: serviceLocator(),
        loginUser: serviceLocator(),
        logoutUser: serviceLocator(),
        saveBiometric: serviceLocator(),
        getBiometric: serviceLocator(),
      ),
    );
}

Future<void> _initSocial() async {
  serviceLocator
    ..registerFactory<SocialRemoteDataSource>(
      () => SocialRemoteDataSourceImpl(
        firebaseAuth: serviceLocator(),
        fireStore: serviceLocator(),
      ),
    )
    ..registerFactory<SocialRepository>(
      () => SocialRepositoryImpl(remoteDataSource: serviceLocator()),
    )
    ..registerFactory(() => SocialUserFollow(repository: serviceLocator()))
    ..registerFactory(() => SocialUserUnfollow(repository: serviceLocator()))
    ..registerFactory(() => SocialUserSearch(repository: serviceLocator()))
    ..registerFactory(
      () => SocialUserGetFollowers(repository: serviceLocator()),
    )
    ..registerFactory(
      () => SocialUserGetFollowings(repository: serviceLocator()),
    )
    ..registerFactory(
      () => SocialGetFollowingsLocation(repository: serviceLocator()),
    )
    ..registerFactory(
      () => SocialUserUpdateLocation(repository: serviceLocator()),
    )
    ..registerLazySingleton(
      () => SocialBloc(
        followUser: serviceLocator(),
        searchUser: serviceLocator(),
        unfollowUser: serviceLocator(),
        getFollowers: serviceLocator(),
        getFollowings: serviceLocator(),
        getFollowingsLocation: serviceLocator(),
        updateLocation: serviceLocator(),
      ),
    );
}
