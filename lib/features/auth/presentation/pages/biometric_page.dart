import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:trackmate/init_dependencies.dart';
import 'package:trackmate/main_page.dart';

class BiometricPage extends StatefulWidget {
  const BiometricPage({super.key});

  @override
  State<BiometricPage> createState() => _BiometricPageState();
}

class _BiometricPageState extends State<BiometricPage> {
  final LocalAuthentication _localAuth = serviceLocator();
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    _startAuthentication();
  }

  Future<void> _startAuthentication() async {
    if (!mounted) return;

    setState(() {
      _isAuthenticating = true;
    });

    try {
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

      bool authenticated = await _localAuth.authenticate(
        localizedReason:
            'لطفا برای ورود به برنامه، اثر انگشت یا چهره خود را اسکن کنید.',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (authenticated && mounted) {
          Navigator.of(
            context,
          ).pushReplacement(MaterialPageRoute(builder: (context) => MainPage()));
        
      } else {
        if (mounted) {
          setState(() {
            _isAuthenticating = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطا در احراز هویت: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.fingerprint, size: 80, color: Colors.blue),
            const SizedBox(height: 24),
            const Text(
              'احراز هویت بیومتریک',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (_isAuthenticating)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _startAuthentication,
                child: const Text('تلاش مجدد'),
              ),
          ],
        ),
      ),
    );
  }
}
