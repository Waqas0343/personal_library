import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app_assets/app-contants/app_constants.dart';
import '../../app_helpers/text_formatter.dart';
import 'controllers/add_book_controller.dart';

class AddBookScreen extends StatelessWidget {
  const AddBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AddBookController controller = Get.put(AddBookController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Book "),
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: const EdgeInsets.all(
            12.0,
          ),
          children: [
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: controller.nameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: "Book Title",
              ),
              validator: (text) {
                if (text!.isEmpty) {
                  return "Can't be empty";
                } else if (!GetUtils.hasMatch(
                  text,
                  TextInputFormatterHelper.numberAndText.pattern,
                )) {
                  return "Book Title ${Keys.bothTextNumber}";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: controller.authorController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: "Book author",
              ),
              validator: (text) {
                if (text!.isEmpty) {
                  return "Can't be empty";
                } else if (!GetUtils.hasMatch(
                  text,
                  TextInputFormatterHelper.numberAndText.pattern,
                )) {
                  return "Book Author ${Keys.bothTextNumber}";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: controller.descriptionController,
              maxLines: 8,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: "Book Description",
                hintText: "Enter book description",
              ),
              validator: (text) {
                if (text!.isEmpty) {
                  return "Description can't be empty";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Obx(
              () => CheckboxListTile(
                title: const Text('Status Book Status (Read/Unread)'),
                value: controller.bookStatus.value,
                onChanged: (value) {
                  controller.toggleBookStatus(value!);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25.0,
                vertical: 10,
              ),
              child: TextButton.icon(
                icon: const Icon(Icons.add_photo_alternate),
                label: FittedBox(
                  child: Text(
                    controller.imagePath.isEmpty
                        ? "Pick Image"
                        : controller.imagePath.substring(0, 44),
                  ),
                ),
                onPressed: controller.pickImage,
              ),
            ),
            ElevatedButton(
              child: const Text(
                "Add New Book",
              ),
              onPressed: () {
                if (controller.formKey.currentState!.validate()) {
                  controller.addBookPress();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
