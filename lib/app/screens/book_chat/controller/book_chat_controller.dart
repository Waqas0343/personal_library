import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../../../app_assets/app-contants/app_constants.dart';
import '../../../app_helpers/crypto_helper.dart';
import '../../../services/notification.dart';


class ChatRoomController extends GetxController {
  late types.Room room;
  RxBool isAttachmentUploading = RxBool(false);
  String? token;
  late types.User currentUser;
  late StreamSubscription streamSubscription;

  @override
  void onInit() async {
    if (Get.arguments != null) {
      room = Get.arguments;
    }

    Get.log(room.id);
    types.User otherUser = room.users.firstWhere(
            (element) => element.id != FirebaseAuth.instance.currentUser?.uid);

    currentUser = room.users.firstWhere(
            (element) => element.id == FirebaseAuth.instance.currentUser?.uid);

    final user = await FirebaseChatCore.instance
        .getFirebaseFirestore()
        .collection(FirebaseChatCore.instance.config.usersCollectionName)
        .doc(otherUser.id)
        .get();

    token = user.data()?["metadata"]?[Keys.token];

    streamSubscription = FirebaseChatCore.instance.messages(room).listen(
          (event) {
        event
            .where((element) =>
        element.author.id == otherUser.id &&
            element.status?.name != types.Status.seen.name)
            .forEach((element) async {
          var doc = FirebaseFirestore.instance
              .doc("rooms/${room.id}/messages/${element.id}");

          await doc.set(
            {
              "status": types.Status.seen.name,
            },
            SetOptions(
              merge: true,
            ),
          );
        });
      },
    );
    super.onInit();
  }

  @override
  void onClose() {
    closeStreams();
    super.dispose();
  }

  Future<void> closeStreams() async {
    await streamSubscription.cancel();
  }

  void handleMessageTap(_, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final updatedMessage = message.copyWith(isLoading: true);
          FirebaseChatCore.instance.updateMessage(
            updatedMessage,
            room.id,
          );

          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          await Dio().download(message.uri, localPath);
        } finally {
          final updatedMessage = message.copyWith(isLoading: false);
          FirebaseChatCore.instance.updateMessage(
            updatedMessage,
            room.id,
          );
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void handleSendPressed(types.PartialText message) async {
    var jsonMessage = {
      "text": CryptoHelper.encryption(message.text),
    };
    types.PartialText messageEncrypted =
    types.PartialText.fromJson(jsonMessage);

    //Send push notification
    if (!GetUtils.isNullOrBlank(token)!) {
      var payload = {
        Keys.actionType: Keys.chatMessage,
        Keys.data: jsonEncode({
          "roomId": room.id,
        })
      };

      Get.find<PushNotificationsManager>().sendNotification(
        token!,
        currentUser.firstName ?? "New Message",
        message.text,
        payload: payload,
      );
    }

    FirebaseChatCore.instance.sendMessage(
      messageEncrypted,
      room.id,
    );
  }

  Future<void> onImageSelection(
      {ImageSource imageSource = ImageSource.gallery}) async {
    final result = await ImagePicker().pickImage(
      imageQuality: 75,
      maxWidth: 1440,
      source: imageSource,
    );

    if (result == null) {
      return;
    }
    setAttachmentUploading(true);

    final file = File(result.path);
    final image = await decodeImageFromList(await result.readAsBytes());

    setAttachmentUploading(false);
    final message = types.PartialImage(
      height: image.height.toDouble(),
      name: result.name,
      size: file.lengthSync(),
      uri: "imagePath",
      width: image.width.toDouble(),
    );

    FirebaseChatCore.instance.sendMessage(
      message,
      room.id,
    );
  }

  String formatTime(DateTime dateTime) {
    return DateFormat('dd MMM, yyyy hh:mm a').format(dateTime);
  }

  void handlePreviewDataFetched(
      types.TextMessage message,
      types.PreviewData previewData,
      ) {
    final updatedMessage = message.copyWith(previewData: previewData);

    FirebaseChatCore.instance.updateMessage(updatedMessage, room.id);
  }

  void setAttachmentUploading(bool value) {
    isAttachmentUploading.value = value;
  }
}