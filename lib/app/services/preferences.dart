import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_widget/app_debug_widget/debug_pointer.dart';
import '../routes/app_routes.dart';

class Preferences extends GetxService {
  late SharedPreferences _preferences;

  Future<Preferences> initial() async {
    _preferences = await SharedPreferences.getInstance();
    return this;
  }

  Future setString(String key, String? value) async {
    if (value == null) return;
    try {
      await _preferences.setString(key, value);
    } catch (e) {
      Debug.log("$e");
    }
  }

  Future setInt(String key, int? value) async {
    if (value == null) return;
    try {
      await _preferences.setInt(key, value);
    } catch (e) {
      Debug.log("$e");
    }
  }

  Future setBool(String key, bool? value) async {
    if (value == null) return;
    try {
      await _preferences.setBool(key, value);
    } catch (e) {
      Debug.log("$e");
    }
  }

  String? getString(String key) {
    try {
      return _preferences.getString(key);
    } catch (e) {
      Debug.log("$e");
    }

    return "";
  }

  int? getInt(String key) {
    try {
      return _preferences.getInt(key);
    } catch (e) {
      Debug.log("$e");
    }
    return 0;
  }

  bool? getBool(String key) {
    try {
      return _preferences.getBool(key);
    } catch (e) {
      Debug.log("$e");
    }
    return null;
  }

  Future clear() async {
    await _preferences.clear();
  }

  Future logout() async {
    await clear();
    Get.offAllNamed(AppRoutes.login);
  }
}
