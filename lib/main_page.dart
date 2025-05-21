import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackmate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:trackmate/features/auth/presentation/bloc/auth_event.dart';
import 'package:trackmate/features/auth/presentation/pages/signup_page.dart';
import 'package:trackmate/features/social/presentation/pages/map_page.dart';
import 'package:trackmate/features/social/presentation/pages/social_page.dart';

import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/pages/profile_page.dart';

class MainPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => MainPage());

  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [MapPage(), SocialPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          Navigator.of(
            context,
          ).pushAndRemoveUntil(SignUpPage.route(), (route) => false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                context.read<AuthBloc>().add(AuthLogout());
              },
              icon: const Icon(Icons.logout_rounded),
            ),
          ],
        ),
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.map_rounded), label: ""),

            BottomNavigationBarItem(
              label: "",
              icon: Icon(Icons.search_rounded),
            ),
            BottomNavigationBarItem(label: "", icon: Icon(Icons.person)),
          ],
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        ),
      ),
    );
  }
}
