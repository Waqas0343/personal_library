import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_assets/app_colors/my_colors.dart';
import '../../app_assets/app_drawer/app_drawer.dart';
import '../../app_assets/app_theme_info/app_theme_info.dart';
import '../../app_widget/custom_card.dart';
import '../../routes/app_routes.dart';
import 'controllers/book_list_controller.dart';
import 'models/book_model.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BookListController controller = Get.put(BookListController());
    return SafeArea(
      child: Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          titleSpacing: 0,
          elevation: 0,
          centerTitle: false,
          title: const Align(
              alignment: Alignment.center, child: Text("Books List")),
          actions: [
            IconButton(
              icon: const Icon(Icons.dark_mode_outlined),
              onPressed: () {
                // Get.find<Preferences>().logout();
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            // Adjust the height as needed
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: TextFormField(
                textInputAction: TextInputAction.search,
                controller: controller.searchController,
                decoration: InputDecoration(
                  hintText: "Search Books",
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius:
                        BorderRadius.circular(AppThemeInfo.borderRadius),
                  ),
                  fillColor: Colors.white,
                  isCollapsed: true,
                  hintStyle: Get.textTheme.titleMedium?.copyWith(
                    color: Colors.grey.shade400,
                  ),
                  contentPadding: const EdgeInsets.all(10.0),
                  suffixIcon: controller.hasSearchText.value
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                            size: 20.0,
                          ),
                          onPressed: () {
                            controller.searchController.clear();
                            Get.focusScope?.unfocus();
                            controller.applyFilter();
                          },
                        )
                      : null,
                ),
                onFieldSubmitted: (text) => controller.applyFilter(),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: "${controller.greeting} ",
                    style: Get.textTheme.titleSmall,
                    children: [
                      TextSpan(
                        text: "Dear!",
                        style: Get.textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemBuilder: (context, index) {
                      BookModel product = controller.books[index];
                      return CustomCard(
                        onLongPressed: () {
                          Get.toNamed(
                            AppRoutes.bookDetailScreen,
                            arguments: product,
                          );
                        },
                        onPressed: () {
                          Get.toNamed(
                            AppRoutes.addBookScreen,
                            arguments: product,
                          );
                        },
                        margin: const EdgeInsets.all(6.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ListTile(
                                leading: product.image.isNotEmpty
                                    ? Image.file(
                                        File(product.image),
                                        width: 64.0,
                                        height: 74.0,
                                        fit: BoxFit.cover,
                                      )
                                    : const SizedBox.shrink(),
                                title: Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 8.0,
                                    ),
                                    Text(
                                      product.author,
                                      style: Get.textTheme.titleSmall,
                                    ),
                                    const SizedBox(
                                      height: 8.0,
                                    ),
                                    Text(
                                      product.description,
                                    ),
                                  ],
                                ),
                                trailing: GestureDetector(
                                  onTap: () {
                                    controller.deleteBook(product);
                                  },
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.toNamed(AppRoutes.bookChatUsersScreen);
                                  },
                                  child: const Align(
                                    alignment: Alignment.bottomRight,
                                    child: Icon(
                                      Icons.chat,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: controller.books.length,
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.toNamed(AppRoutes.addBookScreen),
          backgroundColor: MyColors.primary, // Professional color
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
