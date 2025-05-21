import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackmate/features/auth/presentation/pages/biometric_page.dart';
import 'package:trackmate/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:trackmate/core/common/cubits/app_user/app_user_state.dart';
import 'package:trackmate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:trackmate/features/auth/presentation/bloc/auth_event.dart';
import 'package:trackmate/features/auth/presentation/bloc/auth_state.dart';
import 'package:trackmate/features/auth/presentation/pages/signup_page.dart';
import 'package:trackmate/features/social/presentation/bloc/social_bloc.dart';
import 'package:trackmate/init_dependencies.dart';
import 'package:trackmate/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => serviceLocator<AuthBloc>()),
        BlocProvider(create: (context) => serviceLocator<AppUserCubit>()),
        BlocProvider(create: (context) => serviceLocator<SocialBloc>()),
      ],
      child: const App(),
    ),
  );
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthCurrentUser());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              final userState = context.read<AppUserCubit>().state;

              if (userState is AppUserLoggedIn) {
                context.read<AuthBloc>().add(AuthCheckBiometric());

                if (authState is AuthBiometricSuccess) {
                  return authState.isBiometricEnabled
                      ? BiometricPage()
                      : MainPage();
                }
              }
              if (userState is AppUserNotFound) {
                return SignUpPage();
              }
              return Container(color: Colors.white,child: const Center(child: CircularProgressIndicator()));
            },
          ),
        ),
      ),
    );
  }
}
