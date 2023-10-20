import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

import '../../../app_assets/app-contants/app_constants.dart';
import '../../../app_helpers/connectivity.dart';
import '../../../app_helpers/crypto_helper.dart';
import '../../../app_helpers/toaster.dart';
import '../../../app_widget/app_debug_widget/debug_pointer.dart';
import '../../../app_widget/dialogs/dialog.dart';
import '../../../routes/app_routes.dart';
import '../../../services/preferences.dart';

class LoginController extends GetxController {
  String? loginId;
  String? password;
  final rememberMe = false.obs;
  final RxBool buttonAction = RxBool(true);
  final formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void login() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    buttonAction.value = false;

    Get.dialog(const LoadingSpinner(), barrierDismissible: false);

    if (!await Connectivity.isOnline()) {
      Connectivity.internetNotAvailable();
      buttonAction.value = true;
      Get.back();
      return;
    }

    try {
      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: loginId!,
        password: password!,
      );

      final User? user = userCredential.user;
      if (user != null) {
        // After successful login, save the user data to Firestore
        saveUserData(user);
        Get.offAllNamed(AppRoutes.bookListScreen);
      } else {
        Toaster.showToast('User does not exist.');
      }
    } catch (e) {
      Debug.log(e.toString());
    } finally {
      Get.back();
      buttonAction.value = true;
    }
  }

  void toggleRememberMe(bool? value) {
    if (value != null) {
      rememberMe.value = value;
      Get.find<Preferences>().setBool(Keys.rememberMe, rememberMe.value);
    }
  }

  void saveLoginCredentials(String value) {
    if (rememberMe.value) {
      String? encyPassword =
      password != null ? CryptoHelper.encryption(password!) : null;
      Get.find<Preferences>().setString(Keys.password, encyPassword);
      Get.find<Preferences>().setString(Keys.userId, loginId);
    }
  }

  Future<void> saveUserData(User user) async {
    final firestore = FirebaseFirestore.instance;
    final userDoc = firestore.collection('users').doc(user.uid);
    final userData = {
      'email': user.email,
    };

    await userDoc.set(userData);

  }

  @override
  Future<void> onInit() async {
    super.onInit();
  }
}
