import 'dart:async';
import 'package:get/get.dart';
import '../../../app_assets/app-contants/app_constants.dart';
import '../../../routes/app_routes.dart';
import '../../../services/preferences.dart';

class SplashController extends GetxController {
  final RxBool connectivityError = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    checkLogin();
  }

  Future<void> checkLogin() async {
    connectivityError(false);
    bool status = Get.find<Preferences>().getBool(Keys.status) ?? false;
    bool isFirstTime =
        Get.find<Preferences>().getBool(Keys.isFirstTime) ?? true;

    await 3.0.delay();
    if (status) {
      Get.offNamed(AppRoutes.bookListScreen);
    } else {
      if (isFirstTime) {
        Get.offNamed(AppRoutes.introduction);
      } else {
        Get.offNamed(AppRoutes.login);
      }
    }
  }
}
