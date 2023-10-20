import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../app_helpers/toaster.dart';
import '../../../app_widget/app_debug_widget/debug_pointer.dart';
import '../../../routes/app_routes.dart';

class SignUpController extends GetxController {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final RxBool isLoading = RxBool(false);

  final RxString avatarUrl = RxString('assets/placeholder_image.png');
  final RxBool buttonAction = RxBool(true);
  final formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  Rx<File?> selectedImage = Rx<File?>(null);
  Rx<String?> selectedImageBase64 = Rx<String?>(null);

  Future<void> getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
      final bytes = await File(pickedFile.path).readAsBytes();
      selectedImageBase64.value = base64Encode(bytes);
    }
  }

  Future<void> signUp() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    final firstName = firstNameController.text;
    final lastName = lastNameController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (password != confirmPassword) {

      return;
    }

    isLoading.value = true;

    try {
      final UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (selectedImage.value != null) {
        final Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images/${user?.uid}.jpg');
        final UploadTask uploadTask = storageRef.putFile(selectedImage.value!);
        final TaskSnapshot downloadTask = await uploadTask.whenComplete(() {});
        final String imageUrl = await downloadTask.ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('users').doc(user?.uid).set(
          {
            'firstName': firstName,
            'lastName': lastName,
            'email': email,
            'imageURL': imageUrl,
          },
        );
      }

      Get.offAllNamed(AppRoutes.bookListScreen); // Replace HomePage with your actual home page.
    } catch (e) {
      if (e is FirebaseAuthException) {
        Toaster.showToast(e.message ?? 'An error occurred during sign up.');
      } else {
        Toaster.showToast('An error occurred during sign up.');
      }

      Debug.log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

}
