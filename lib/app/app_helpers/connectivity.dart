import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app_widget/app_debug_widget/debug_pointer.dart';


class Connectivity {
  static Future<bool> isOnline() async {
    try {
      final result = await InternetAddress.lookup('google.com').timeout(
        const Duration(
          seconds: 10,
        ),
        onTimeout: () {
          return [];
        },
      );
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Debug.log('connected');
        return true;
      }
    } on SocketException catch (_) {
      Debug.log('not connected');
    } catch (e) {
      Debug.log(e);
    }
    return false;
  }

  static Future<void> internetNotAvailable() {
    return Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_off,
              size: 60,
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'No Internet Connection',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontFamily: "Roboto",
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              'Internet access is required \nto use this feature.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: 120,
              child: OutlinedButton(
                onPressed: () => Get.back(),
                // highlightedBorderColor: Theme.of(context).accentColor,
                child: const Text("Cancel"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
