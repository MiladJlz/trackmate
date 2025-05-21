import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackmate/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:trackmate/core/usecase/usecase.dart';
import 'package:trackmate/features/auth/domain/usecases/current_user.dart';
import 'package:trackmate/features/auth/domain/usecases/get_biometric.dart';
import 'package:trackmate/features/auth/domain/usecases/login_user.dart';
import 'package:trackmate/features/auth/domain/usecases/logout_user.dart';
import 'package:trackmate/features/auth/domain/usecases/save_biometric.dart';
import 'package:trackmate/features/auth/domain/usecases/signup_user.dart';
import 'package:trackmate/features/auth/presentation/bloc/auth_event.dart';
import 'package:trackmate/features/auth/presentation/bloc/auth_state.dart';
import 'package:trackmate/init_dependencies.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AppUserCubit _appUserCubit;
  final CurrentUser _currentUser;
  final UserLogin _userLogin;
  final UserLogout _userLogout;
  final UserSignUp _userSignUp;
  final SaveBiometric _saveBiometric;
  final GetBiometric _getBiometric;

  AuthBloc({
    required UserSignUp signUpUser,
    required UserLogin loginUser,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
    required UserLogout logoutUser,
    required SaveBiometric saveBiometric,
    required GetBiometric getBiometric,
  }) : _userSignUp = signUpUser,
       _userLogin = loginUser,
       _currentUser = currentUser,
       _appUserCubit = appUserCubit,
       _userLogout = logoutUser,
       _saveBiometric = saveBiometric,
       _getBiometric = getBiometric,
       super(AuthInitial()) {
    on<AuthEvent>((_, emmit) => emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthLogout>(_onAuthLogout);
    on<AuthCurrentUser>(_onAuthCurrentUser);
    on<AuthToggleBiometric>(_onAuthToggleBiometric);
    on<AuthCheckBiometric>(_onAuthCheckBiometric);
    on<AuthSaveBiometric>(_onAuthSaveBiometric);
  }

  void _onAuthCurrentUser(
    AuthCurrentUser event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final res = await _currentUser(NoParams());
    
    res.fold((failure) =>  _appUserCubit.updateUser(null), (user) {
      _appUserCubit.updateUser(user);
      emit(AuthSuccess(user: user));
    });
  }

  void _onAuthLogout(AuthLogout event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userLogout(NoParams());
    if (res != null) {
      emit(AuthFailure(message: 'Logout failed'));
    } else {
      _appUserCubit.updateUser(null);
      emit(AuthInitial());
    }
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final firestore = serviceLocator<FirebaseFirestore>();
    firestore.runTransaction((transaction) async {});

    final res = await _userSignUp(
      SignUpParams(
        email: event.email,
        password: event.password,
        username: event.username,
      ),
    );
    res.fold((failure) => emit(AuthFailure(message: failure.message)), (user) {
      _appUserCubit.updateUser(user);
      emit(AuthSuccess(user: user));
    });
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userLogin(
      LoginParams(email: event.email, password: event.password),
    );
    res.fold((failure) => emit(AuthFailure(message: failure.message)), (user) {
      _appUserCubit.updateUser(user);
      emit(AuthSuccess(user: user));
    });
  }

  Future<void> _onAuthToggleBiometric(
    AuthToggleBiometric event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final res = await _saveBiometric(SaveBiometricParam(isBiometricEnabled: event.isEnabled));
    res.fold((failure) => emit(AuthBiometricFailure(message: failure.message)),
        (isBiometricEnabled) {
      emit(AuthBiometricSuccess(isBiometricEnabled: isBiometricEnabled));
    });
  }

  Future<void> _onAuthCheckBiometric(
    AuthCheckBiometric event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final res = await _getBiometric(NoParams());
    res.fold((failure) => emit(AuthBiometricFailure(message: failure.message)),
        (isBiometricEnabled) {
      emit(AuthBiometricSuccess(isBiometricEnabled: isBiometricEnabled));
    });
  }

  Future<void> _onAuthSaveBiometric(
    AuthSaveBiometric event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final res = await _saveBiometric(SaveBiometricParam(isBiometricEnabled: event.isBiometricEnabled));
    res.fold((failure) => emit(AuthBiometricFailure(message: failure.message)),
        (isBiometricEnabled) {
      emit(AuthBiometricSuccess(isBiometricEnabled: isBiometricEnabled));
    });
  }
}
