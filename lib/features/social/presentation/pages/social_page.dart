import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackmate/core/common/widgets/loader.dart';
import 'package:trackmate/core/utils/show_snackbar.dart';
import 'package:trackmate/features/social/presentation/bloc/social_bloc.dart';
import 'package:trackmate/features/social/presentation/bloc/social_event.dart';
import 'package:trackmate/features/social/presentation/bloc/social_state.dart';

class SocialPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SocialPage());

  const SocialPage({super.key});

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(title: const Text('جستجوی کاربران')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                if (value.isNotEmpty) {
                  context.read<SocialBloc>().add(
                    SearchUserEvent(username: value.trim()),
                  );
                }
              },
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'نام کاربری را وارد کنید',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocConsumer<SocialBloc, SocialState>(
              listener: (context, state) {
                if (state is FollowSuccess) {
                  showSnackBar(context, state.message);
                } else if (state is FollowError) {
                  showSnackBar(context, state.message);
                } else if (state is UnfollowSuccess) {
                  showSnackBar(context, state.message);
                } else if (state is UnfollowError) {
                  showSnackBar(context, state.message);
                } else if (state is SocialError) {
                  showSnackBar(context, state.message);
                }
              },
              builder: (context, state) {
                if (state is SocialLoading) {
                  return const Center(child: Loader());
                } else if (state is SocialLoaded) {
                  return ListView.builder(
                    itemCount: state.users.length,
                    itemBuilder: (context, index) {
                      final user = state.users[index];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(user.username?[0].toUpperCase() ?? ''),
                        ),
                        title: Text(user.username ?? ''),
                        trailing: IconButton(
                          icon: Icon(state.followings.contains(user.id)
                              ? Icons.person_remove
                              : Icons.person_add),
                          onPressed: () => context.read<SocialBloc>().add(
                                state.followings.contains(user.id)
                                    ? UnfollowUserEvent(userId: user.id)
                                    : FollowUserEvent(userId: user.id),
                              ),
                        ),
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
