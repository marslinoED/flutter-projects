import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? sharedPreferences;

  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> putBoolean({
    required String key,
    required bool value,
  }) async {
    return await sharedPreferences!.setBool(key, value);
  }

  static bool getBoolean({required String key}) {
    if(sharedPreferences?.getBool(key) == null) {
      putBoolean(key: key, value: true);
    }
    return sharedPreferences?.getBool(key) ?? true; 
  }
  static Future<bool> putInt({
    required String key,
    required int value,
  }) async {
    return await sharedPreferences!.setInt(key, value);
  }

  static int getInt({required String key}) {
    if(sharedPreferences?.getInt(key) == null) {
      putInt(key: key, value: 0);
    }
    return sharedPreferences?.getInt(key) ?? 0; 
  }
}
