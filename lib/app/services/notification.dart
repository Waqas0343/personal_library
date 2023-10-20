import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../app_assets/app-contants/app_constants.dart';
import '../app_widget/app_debug_widget/debug_pointer.dart';
import '../routes/app_routes.dart';

class PushNotificationsManager extends GetxService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin localNotification =
      FlutterLocalNotificationsPlugin();

  Future<PushNotificationsManager> init() async {
    await _messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    await localNotification.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (notificationResponse) {
        if (notificationResponse.payload != null) {
          final Map<String, dynamic> payload =
              jsonDecode(notificationResponse.payload!);

          String action = payload[Keys.actionType];
          final data = jsonDecode(payload[Keys.data]);

          navigate(
            action,
            payload: data,
          );
        }
      },
    );

    // foreground
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) =>
          notificationDecide(message, isForeground: true),
    );
    return this;
  }

  void notificationDecide(RemoteMessage? message, {bool isForeground = false}) {
    if (message == null) return;

    Debug.log("Notification Data::: ${message.data}");

    RemoteNotification? notification = message.notification;
    String? action = message.data[Keys.actionType];
    Map<String, dynamic>? payload;
    if (!GetUtils.isNullOrBlank(message.data[Keys.data])!) {
      payload = json.decode(message.data[Keys.data]);
    }

    String title = notification?.title ?? "Notification Title";
    String body = notification?.body ?? "Notification Body";

    if (isForeground) {
      if (action == Keys.chatMessage &&
          Get.currentRoute == AppRoutes.bookChatScreen) {
        return;
      }

      showLocalNotification(
        title: title,
        body: body,
        payload: json.encode(message.data),
      );
    } else {
      navigate(
        action,
        payload: payload,
      );
    }
  }

  /// make sure you initialized [_messaging] and [localNotification] before
  Future<void> backgroundNotificationHandler() async {
    // background
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) => notificationDecide(
        message,
      ),
    );

    // terminate
    _messaging.getInitialMessage().then(
          (RemoteMessage? message) => notificationDecide(message),
        );

    final notificationDetails =
        await localNotification.getNotificationAppLaunchDetails();

    if (notificationDetails?.notificationResponse?.payload != null) {
      final Map<String, dynamic> payload =
          jsonDecode(notificationDetails!.notificationResponse!.payload!);

      String action = payload[Keys.actionType];
      final data = jsonDecode(payload[Keys.data]);

      navigate(
        action,
        payload: data,
      );
    }
  }

  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    var android = const AndroidNotificationDetails(
      Keys.channelCriticalId,
      Keys.channelCriticalName,
      channelDescription: "",
      styleInformation: BigTextStyleInformation(""),
    );
    var ios = const DarwinNotificationDetails();
    var platform = NotificationDetails(android: android, iOS: ios);

    await localNotification.show(
      0,
      title,
      body,
      platform,
      payload: payload,
    );
  }

  Future<void> navigate(String? type, {Map<String, dynamic>? payload}) async {
    if (type == Keys.chatMessage) {
      var room =
          await FirebaseChatCore.instance.room(payload?[Keys.roomId]).first;
      Get.toNamed(
        AppRoutes.bookChatScreen,
        arguments: room,
      );
    }
  }

  Future<bool> sendNotification(
    String to,
    String title,
    String body, {
    Map<String, dynamic>? payload,
  }) async {
    final HttpsCallable function = FirebaseFunctions.instance.httpsCallable("sendMessage");

    try {
      var results = await function.call(<String, dynamic>{
        "token": to,
        "title": title,
        "body": body,
        "payload": payload
      });

      Get.log(results.data);
      return results.data["successCount"] > 0;
    } catch (_) {}
    return false;
  }
}
