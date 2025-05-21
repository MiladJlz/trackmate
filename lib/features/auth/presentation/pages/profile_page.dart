import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:trackmate/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:trackmate/core/common/cubits/app_user/app_user_state.dart';
import 'package:trackmate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:trackmate/features/auth/presentation/bloc/auth_event.dart';
import 'package:trackmate/features/auth/presentation/bloc/auth_state.dart';
import 'package:trackmate/features/social/presentation/bloc/social_bloc.dart';
import 'package:trackmate/features/social/presentation/bloc/social_event.dart';
import 'package:trackmate/features/social/presentation/bloc/social_state.dart';
import 'package:trackmate/init_dependencies.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final LocalAuthentication _localAuth = serviceLocator();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SocialBloc>().add(GetFollowersEvent());
      context.read<SocialBloc>().add(GetFollowingsEvent());
      context.read<AuthBloc>().add(AuthCheckBiometric());
    });
  }

  Future<void> _toggleBiometric() async {
    bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
    if (!canCheckBiometrics) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('دستگاه شما از بیومتریک پشتیبانی نمی‌کند.'),
          ),
        );
      }
      return;
    }

    final currentState = context.read<AuthBloc>().state;
    bool isCurrentlyEnabled = false;
    if (currentState is AuthBiometricSuccess) {
      isCurrentlyEnabled = currentState.isBiometricEnabled;
    }

    if (!mounted) return;

    await showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setDialogState) => AlertDialog(
                  title: const Text('تنظیمات بیومتریک'),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('احراز هویت بیومتریک'),
                      Switch(
                        value: isCurrentlyEnabled,
                        onChanged: (value) async {
                          if (value) {
                            try {
                              bool
                              authenticated = await _localAuth.authenticate(
                                localizedReason:
                                    'لطفا برای فعال کردن احراز هویت بیومتریک، اثر انگشت یا چهره خود را اسکن کنید.',
                              );

                              if (authenticated) {
                                context.read<AuthBloc>().add(
                                  AuthToggleBiometric(isEnabled: value),
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('خطا در احراز هویت: $e'),
                                  ),
                                );
                              }
                            }
                          } else {
                            context.read<AuthBloc>().add(
                              AuthToggleBiometric(isEnabled: value),
                            );
                          }
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('بستن'),
                    ),
                  ],
                ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('پروفایل'),
        actions: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  context.read<AuthBloc>().add(AuthCheckBiometric());
                  _toggleBiometric();
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<AppUserCubit, AppUserState>(
              builder: (context, state) {
                if (state is AppUserLoggedIn) {
                  final user = state.user;
                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        child: Text(
                          user.username != null && user.username!.isNotEmpty
                              ? user.username![0].toUpperCase()
                              : '?',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.username ?? '-',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            user.email,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BlocBuilder<SocialBloc, SocialState>(
                  builder: (context, state) {
                    int followers = 0;
                    if (state is GetFollowersSuccess) {
                      followers = state.followers.length;
                    }
                    return Column(
                      children: [
                        Text(
                          '$followers',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('دنبال‌کننده'),
                      ],
                    );
                  },
                ),
                BlocBuilder<SocialBloc, SocialState>(
                  builder: (context, state) {
                    int followings = 0;
                    if (state is GetFollowingsSuccess) {
                      followings = state.followings.length;
                    }
                    return Column(
                      children: [
                        Text(
                          '$followings',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('دنبال‌شوندگان'),
                      ],
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            BlocBuilder<SocialBloc, SocialState>(
              builder: (context, state) {
                if (state is GetFollowingsSuccess &&
                    state.followings.isNotEmpty) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.followings.length,
                    itemBuilder: (context, index) {
                      final followingId = state.followings[index];
                      return ListTile(
                        title: Text(followingId),
                        trailing: IconButton(
                          icon: const Icon(Icons.person_remove),
                          onPressed: () {
                            context.read<SocialBloc>().add(
                              UnfollowUserEvent(userId: followingId),
                            );
                            context.read<SocialBloc>().add(
                              GetFollowingsEvent(),
                            );
                          },
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
