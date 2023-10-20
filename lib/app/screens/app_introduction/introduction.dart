import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import '../../app_assets/app_colors/my_colors.dart';
import 'controller/introduction_controller.dart';

class AppIntroScreen extends StatelessWidget {
  const AppIntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(IntroController());

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: IntroductionScreen(
        // globalBackgroundColor: Get.theme.primaryColor,
        pages: controller.pages,
        onDone: () => controller.moveToHome(),
        done: Text(
          "Get Started",
          style: Get.theme.textTheme.titleSmall!.copyWith(
            fontWeight: FontWeight.w700,
            color: MyColors.primary,
          ),
        ),
        dotsDecorator: const DotsDecorator(
          activeColor: MyColors.primary,
          activeSize: Size.fromRadius(6.5),
        ),
        showNextButton: true,
        next: const Icon(
          Icons.arrow_forward,
          color:MyColors.primary,
        ),
        showSkipButton: true,
        skip: Text(
          "Skip",
          style: Get.theme.textTheme.titleSmall!.copyWith(
            fontWeight: FontWeight.w400,
            color: MyColors.primary,
          ),
        ),
        skipOrBackFlex: 0,
        nextFlex: 0,
        onSkip: () => controller.moveToHome(),
      ),
    );
  }
}
