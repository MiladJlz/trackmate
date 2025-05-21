import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppSecrets {
  static String? get androidAppId => dotenv.env['ANDROID_APP_ID'];
  static String? get webAppId => dotenv.env['WEB_APP_ID'];
  static String? get webApiKey => dotenv.env['WEB_API_KEY'];
  static String? get projectId => dotenv.env['PROJECT_ID'];
  static String? get storageBucket => dotenv.env['STORAGE_BUCKET'];
  static String? get messagingSenderId => dotenv.env['MESSAGING_SENDER_ID'];

  static Future<void> load() async {
    await dotenv.load(fileName: ".env");
  }
}
