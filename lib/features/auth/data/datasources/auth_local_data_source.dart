import 'package:shared_preferences/shared_preferences.dart';

abstract interface class AuthLocalDataSource {
  Future<void> saveBiometricState(bool isBiometricEnabled);
  Future<bool> getBiometricState();
}

class AuthLocalDataSourceImpl extends AuthLocalDataSource {
  final SharedPreferences prefs;
   AuthLocalDataSourceImpl({required this.prefs});
  @override
  Future<void> saveBiometricState(bool isBiometricEnabled) async {
    await prefs.setBool('isBiometricEnabled', isBiometricEnabled);
  }

  @override
  Future<bool> getBiometricState() async {
    return prefs.getBool('isBiometricEnabled') ?? false;
  }
}
