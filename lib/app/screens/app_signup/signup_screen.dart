import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../app_assets/app-contants/app_constants.dart';
import '../../app_assets/app_colors/my_colors.dart';
import '../../app_assets/my_images.dart';
import '../../app_helpers/text_formatter.dart';
import 'controller/app_signup_controller.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SignUpController controller = Get.put(SignUpController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: const Icon(Icons.camera),
                                  title: const Text('Take a Photo'),
                                  onTap: () {
                                    controller.getImage(ImageSource.camera);
                                    Get.back();
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.image),
                                  title: const Text('Choose from Gallery'),
                                  onTap: () async {
                                    controller.getImage(ImageSource.gallery);
                                    Get.back();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Obx(
                            () {
                              final selectedImage = controller.selectedImage.value;
                              return Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  CircleAvatar(
                                    radius: 70,
                                    backgroundImage: selectedImage != null
                                        ? Image.file(selectedImage).image // Cast to ImageProvider
                                        : const AssetImage(MyImages.logo),
                                  ),
                                ],
                              );
                            },
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle, // Circular shape
                                color: MyColors
                                    .primary, // Add your desired background color
                              ),
                              padding: const EdgeInsets.all(8),
                              // Adjust the padding as needed
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                size: 32,
                                color: Colors.white, // Icon color
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                TextFormField(
                  controller: controller.firstNameController,
                  keyboardType: TextInputType.text,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                  ),
                  validator: (text) {
                    if (text!.isEmpty) {
                      return "Can't be empty";
                    } else if (!GetUtils.hasMatch(
                      text,
                      TextInputFormatterHelper.numberAndTextWithDot.pattern,
                    )) {
                      return "First Name ${Keys.bothTextNumber}";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12.0),
                TextFormField(
                  controller: controller.lastNameController,
                  keyboardType: TextInputType.text,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                  ),
                  validator: (text) {
                    if (text!.isEmpty) {
                      return "Can't be empty";
                    } else if (!GetUtils.hasMatch(
                      text,
                      TextInputFormatterHelper.numberAndTextWithDot.pattern,
                    )) {
                      return "First Name ${Keys.bothTextNumber}";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12.0),
                TextFormField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: (text) {
                    if (text!.isEmpty) {
                      return "Can't be empty";
                    } else if (!GetUtils.hasMatch(
                      text,
                      TextInputFormatterHelper.validEmail.pattern,
                    )) {
                      return "First Name ${Keys.bothTextNumber}";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12.0),
                TextFormField(
                  controller: controller.passwordController,
                  keyboardType: TextInputType.text,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 12.0),
                TextFormField(
                  obscureText: true,
                  controller: controller.confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                  ),
                  validator: (text) {
                    if (text!.isEmpty) {
                      return "Can't be empty";
                    } else if (!GetUtils.hasMatch(
                      text,
                      TextInputFormatterHelper.validEmail.pattern,
                    )) {
                      return "First Name ${Keys.bothTextNumber}";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      {
                        controller.signUp();
                      }
                    },
                    child: Text(
                      "Sign Up",
                      style: Get.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: MyColors.shimmerHighlightColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
