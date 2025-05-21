import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackmate/core/common/cubits/app_user/app_user_state.dart';
import 'package:trackmate/core/common/domain/entities/user_entity.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserInitial());

  void updateUser(UserEntity? user) {
    if (user == null) {
      emit(AppUserNotFound());
    } else {
      emit(AppUserLoggedIn(user: user));
    }
  }
}
