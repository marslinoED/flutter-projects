import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value == null) return await sharedPreferences!.setString('key', 'null');

    if (value is String) return await sharedPreferences!.setString(key, value);
    if (value is int) return await sharedPreferences!.setInt(key, value);
    if (value is bool) return await sharedPreferences!.setBool(key, value);
    return await sharedPreferences!.setDouble(key, value);
  }

  static dynamic getData({required String key}) {
    if (sharedPreferences?.get(key) == null) {
      saveData(key: key, value: null);
    }
    return sharedPreferences?.get(key);
  }

  static Future<bool> removeData({required String key}) async {
    if (sharedPreferences?.containsKey(key) == true)
      return await sharedPreferences!.remove(key);
    return false;
  }
}
