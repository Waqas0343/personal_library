import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app_assets/app-contants/app_constants.dart';
import '../../../app_widget/app_debug_widget/debug_pointer.dart';
import '../../../services/preferences.dart';
import '../../../app_helpers/database_helper.dart';
import '../models/book_model.dart';

class BookListController extends GetxController {
  RxList books = [].obs;
  final RxBool hasSearchText = RxBool(false);
  final TextEditingController searchController = TextEditingController();
  String name = Get.find<Preferences>().getString(Keys.userId) ?? "Guest User";
  RxBool showSearchField = false.obs;

  @override
  void onInit() {
    getBooks();
    super.onInit();
  }

  getBooks() async {
    BooksDatabaseHelper.db
        .getBookList()
        .then((productList) => {books.value = productList});
  }

  void deleteBook(BookModel book) {
    if (book.id != null) {
      BooksDatabaseHelper.db
          .deleteBook(book.id!)
          .then((_) => books.remove(book));
    } else {
      Debug.log('Cannot delete product with null id.');
    }
  }

  void updateList(BookModel product) async {
    var result = await getBooks();
    if (result != null) {
      final index = books.indexOf(product);
      Debug.log(index);
      books[index] = product;
    }
  }

  void updateBook(BookModel book) {
    BooksDatabaseHelper.db.updateBook(book).then((value) => updateList(book));
  }

  void applyFilter() {
    String searchText = searchController.text.toLowerCase();
    if (searchText.isEmpty) {
      getBooks();
    } else {
      books.value = books
          .where((book) =>
              book.name.toLowerCase().contains(searchText) ||
              book.author.toLowerCase().contains(searchText))
          .toList();
    }
  }
  String get greeting {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  @override
  void onClose() {
    BooksDatabaseHelper.db.close();
    super.onClose();
  }
}
