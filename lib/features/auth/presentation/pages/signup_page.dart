import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackmate/core/utils/show_snackbar.dart';
import 'package:trackmate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:trackmate/features/auth/presentation/bloc/auth_event.dart';
import 'package:trackmate/features/auth/presentation/bloc/auth_state.dart';
import 'package:trackmate/features/auth/presentation/pages/signin_page.dart';
import 'package:trackmate/features/auth/presentation/widgets/auth_field.dart';
import 'package:trackmate/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:trackmate/main_page.dart';

class SignUpPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => SignUpPage());

  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (BuildContext context, state) {
            if (state is AuthFailure) {
              showSnackBar(context, state.message);
            } else if (state is AuthSuccess) {
              Navigator.of(
                context,
              ).pushAndRemoveUntil(MainPage.route(), (route) => false);
            }
          },
          builder: (context, state) {
            return Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ثبت نام',
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),
                  AuthField(
                    hintText: 'نام کاربری',
                    controller: usernameController,
                  ),
                  SizedBox(height: 15),
                  AuthField(hintText: 'ایمیل', controller: emailController),
                  SizedBox(height: 15),
                  AuthField(
                    isObscureText: true,
                    hintText: 'رمز عبور',
                    controller: passwordController,
                  ),
                  SizedBox(height: 20),
                  AuthGradientButton(
                    buttonText: 'ثبت نام',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                          AuthSignUp(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                            username: usernameController.text.trim(),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, SignInPage.route());
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'قبلاً ثبت نام کرده‌اید؟ ',
                        style: Theme.of(context).textTheme.titleMedium,
                        children: [
                          TextSpan(
                            text: 'ورود',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
