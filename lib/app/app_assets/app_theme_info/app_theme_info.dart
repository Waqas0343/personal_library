import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_colors/my_colors.dart';

class AppThemeInfo {
  static double get borderRadius => 30.0;

  static ThemeData get themeData =>
      ThemeData(
          primaryColor: MyColors.primary,

          fontFamily: "VAGRounded",
          scaffoldBackgroundColor: Colors.grey.shade200,
          appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(color: Colors.white),
              centerTitle: false,
              systemOverlayStyle: SystemUiOverlayStyle.light,
              toolbarTextStyle: TextStyle(color: Colors.white,
                  fontSize: 18,
                  fontFamily: "VAGRounded",
                  fontWeight: FontWeight.w600)
          ),
          tabBarTheme: TabBarTheme(
              unselectedLabelColor: Colors.grey.shade300,
              labelColor: Colors.white,
              labelStyle: const TextStyle(fontWeight: FontWeight.w500)
          ),
          bottomAppBarTheme: const BottomAppBarTheme(
              color: Colors.white,
              elevation: 0
          ),
          cupertinoOverrideTheme: const CupertinoThemeData(
              primaryColor: MyColors.primary
          ),
          primaryIconTheme: const IconThemeData(color: MyColors.icons),
          dividerColor: MyColors.divider,
          buttonTheme: ButtonThemeData(
            buttonColor: MyColors.accent,
            textTheme: ButtonTextTheme.primary,
            padding: const EdgeInsets.all(12.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
          ),
          textTheme: const TextTheme(displayLarge: TextStyle(
              fontWeight: FontWeight.w500, color: Colors.black)),
          inputDecorationTheme: InputDecorationTheme(
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(
                      AppThemeInfo.borderRadius))),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12)
          ),
          cardTheme: CardTheme(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius)
              )
          ),
          textSelectionTheme: TextSelectionThemeData(
              cursorColor: MyColors.primary,
              selectionHandleColor: MyColors.primary,
              selectionColor: MyColors.primary.withOpacity(0.5)),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.accent,
                textStyle: const TextStyle(fontWeight: FontWeight.w500),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      AppThemeInfo.borderRadius),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              )
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      AppThemeInfo.borderRadius),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontWeight: FontWeight.w500),
                side: const BorderSide(color: MyColors.primary),
              )
          ),
          colorScheme: const ColorScheme.light(primary: MyColors.primary)
              .copyWith(secondary: MyColors.accent)
      );

}