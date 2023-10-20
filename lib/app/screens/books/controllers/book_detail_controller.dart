import 'package:get/get.dart';

import '../models/book_model.dart';



class BookDetailScreenController extends GetxController {
  final Rxn<BookModel> bookDetailData = Rxn<BookModel>();

  @override
  void onInit() {
    bookDetailData.value = Get.arguments;
    super.onInit();
  }
}
