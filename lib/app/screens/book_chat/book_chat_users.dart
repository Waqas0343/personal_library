import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app_widget/custom_card.dart';
import '../../routes/app_routes.dart';
import 'controller/book_chat_user_controller.dart';

class ChatUserScreen extends StatelessWidget {
  const ChatUserScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final BookChatUserController controller = Get.put(BookChatUserController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Users"),
      ),
      body: Obx(
        () {
          if (controller.users.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: controller.users.length,
              itemBuilder: (context, index) {
                final user = controller.users[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomCard(
                    onPressed: (){
                        Get.toNamed(AppRoutes.bookChatScreen);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(user.displayName),
                        subtitle: Text(user.email),
                        // Add more fields as needed
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
