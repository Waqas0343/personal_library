import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import 'controllers/book_detail_controller.dart';
import 'controllers/book_list_controller.dart';

class BookDetailScreen extends StatelessWidget {
  const BookDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BookDetailScreenController controller = Get.put(BookDetailScreenController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Detail Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image at the top
            Image.file(
              File(controller.bookDetailData.value!.image),
              width: 100.0,
              height: 200.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16), // Spacing
            const Divider(
              thickness: 5,
            ), // Divider
            const SizedBox(height: 16), // Spacing

            // Book name
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: "Book Name:  ",
                    style: Get.textTheme.titleSmall,
                    children: [
                      TextSpan(
                        text: controller.bookDetailData.value!.name,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        Get.toNamed(
                          AppRoutes.addBookScreen,
                          arguments: controller.bookDetailData.value!,
                        );
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.find<BookListController>()
                            .deleteBook(controller.bookDetailData.value!);
                      },
                      child: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8), // Spacing

            // Author name
            Text(
              "Author: ${controller.bookDetailData.value!.author}",
              style: Get.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8), // Spacing

            // Book description
            Text(
              "Description: ${controller.bookDetailData.value!.description}",
              style: Get.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
