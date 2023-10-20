import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../app_assets/app-contants/app_constants.dart';
import '../../app_assets/app_colors/my_colors.dart';
import '../../app_assets/my_images.dart';
import '../../app_helpers/text_formatter.dart';
import '../../routes/app_routes.dart';
import 'controller/login_screen_controller.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      extendBodyBehindAppBar: true,
      body: GestureDetector(
        onTap: () => Get.focusScope?.unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 40.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: Image.asset(
                    MyImages.logo,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 40.0),
                AutofillGroup(
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          autofillHints: const [AutofillHints.username],
                          controller: controller.phoneController,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: "Email",
                          ),
                          validator: (text) {
                            if (text!.isEmpty) {
                              return "Can't be empty";
                            } else if (!GetUtils.hasMatch(
                              text,
                              TextInputFormatterHelper.validEmail.pattern,
                            )) {
                              return "Login ID ${Keys.bothTextNumber}";
                            }
                            return null;
                          },
                          onSaved: (text) => controller.loginId = text,
                          onChanged: controller.saveLoginCredentials,
                        ),
                        const SizedBox(height: 12.0),
                        TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          autofillHints: const [AutofillHints.password],
                          controller: controller.passwordController,
                          obscureText: true,
                          validator: (text) {
                            if (text!.isEmpty) return "Can't be empty";
                            return null;
                          },
                          onSaved: (text) => controller.password = text,
                          onChanged: controller.saveLoginCredentials,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          minLeadingWidth: 0,
                          horizontalTitleGap: 2,
                          leading: SizedBox(
                            width: 32,
                            child: Obx(
                              () => CheckboxListTile(
                                value: controller.rememberMe.value,
                                onChanged: (value) {
                                  controller.toggleRememberMe(value);
                                  TextInput.finishAutofillContext();
                                },
                              ),
                            ),
                          ),
                          title: Text(
                            'Remember Me',
                            style: Get.textTheme.bodyLarge?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Obx(
                            () {
                              return ElevatedButton(
                                onPressed: controller.buttonAction.value
                                    ? () {
                                        TextInput.finishAutofillContext();
                                        controller.login();
                                      }
                                    : null,
                                child: Text(
                                  "Login",
                                  style: Get.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: MyColors.shimmerHighlightColor),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              {
                                Get.toNamed(AppRoutes.signup);
                              }
                            },
                            child: Text(
                              "Sign Up",
                              style: Get.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: MyColors.blueColor,
                              ),
                            ),
                          ),
                        ),
                      ],
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
