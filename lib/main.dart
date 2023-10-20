import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:permission_handler/permission_handler.dart';
import 'app/app_assets/app_colors/my_colors.dart';
import 'app/app_assets/app_theme_info/app_theme_info.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/services/services.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Services().initServices();

  if (await Permission.appTrackingTransparency.request().isGranted) {
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  } else {
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: MyColors.primary));
    return GetMaterialApp(
      initialRoute: AppRoutes.splash,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      getPages: AppPages.pages,
      theme: AppThemeInfo.themeData,
    );
  }
}
