import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';

import '../../app_assets/my_images.dart';
import 'controller/book_chat_controller.dart';

class ChatAppBar extends StatelessWidget implements  PreferredSizeWidget {
  const ChatAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatRoomController>();
    return StreamBuilder<types.Room>(
      stream: FirebaseChatCore.instance.room(controller.room.id),
      builder: (context, snapshot) {
        final types.Room? room = snapshot.data;
        return AppBar(
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            borderRadius: BorderRadius.circular(30),
            child: Row(
              children: [
                const Icon(
                  Icons.arrow_back,
                  size: 22,
                ),
                CachedNetworkImage(
                  imageUrl: "${room?.imageUrl}",
                  height: 35,
                  width: 35,
                  imageBuilder: (_, imageProvider) {
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  placeholder: (_, __) => const CircleAvatar(
                    backgroundImage: AssetImage(MyImages.imageNotFound),
                  ),
                  errorWidget: (_, __, ___) => const CircleAvatar(
                    backgroundImage: AssetImage(MyImages.imageNotFound),
                  ),
                ),
              ],
            ),
          ),
          centerTitle: false,
          leadingWidth: 70,
          titleSpacing: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                room?.name ?? 'Loading...',
                style: Get.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              // todo: offline and online user
              // Text(
              //   "Online",
              //   style: Get.textTheme.titleSmall?.copyWith(
              //     color: Colors.lightGreen,
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
