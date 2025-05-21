import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackmate/core/common/widgets/loader.dart';
import 'package:trackmate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:trackmate/features/auth/presentation/bloc/auth_state.dart';


class AuthGradientButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const AuthGradientButton(
      {super.key, required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
      
        borderRadius: BorderRadius.circular(7),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(395, 55),
       
        ),
        child: BlocSelector<AuthBloc, AuthState, bool>(
          selector: (AuthState state) {
            return state is AuthLoading;
          },
          builder: (BuildContext context, bool isLoading) {
            if (isLoading) {
              return const Loader();
            }
            return Text(
              buttonText,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            );
          },
        ),
      ),
    );
  }
}
