import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../app_helpers/database_helper.dart';
import '../../../app_widget/app_debug_widget/debug_pointer.dart';
import '../models/book_model.dart';
import 'book_list_controller.dart';

class AddBookController extends GetxController {
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  RxBool bookStatus = RxBool(false);
  var imagePath = "";
  RxList books = [].obs;

  var picker = ImagePicker();

  @override
  void onInit() {
    if (Get.arguments != null) {
      final args = Get.arguments;
      nameController.text = args.name;
      descriptionController.text = args.description;
      authorController.text = args.author.toString();
      imagePath = args.image;
      bookStatus.value = args.status;
    }
    super.onInit();
  }

  void addBookPress() {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    if (Get.arguments != null) {
      handleAddButton(Get.arguments.id);
    } else {
      handleAddButton();
    }
    Get.back();
  }

  void pickImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        imagePath = pickedFile.path;
      }
    } catch (e) {
      Debug.log(e);
    }
  }

  void addBook(BookModel book) {
    if (book.id != null) {
      BooksDatabaseHelper.db.updateBook(book).then((value) {
        Get.find<BookListController>().updateBook(book);
        Get.find<BookListController>().getBooks();
      });
    } else {
      BooksDatabaseHelper.db.insertBook(book).then((value) {
        books.add(book);
        update();
        Get.find<BookListController>().getBooks();
      });
    }
  }

  void handleAddButton([id]) {
    if (id != null) {
      var book = BookModel(
        id: id,
        name: nameController.text,
        description: descriptionController.text,
        author: authorController.text,
        image: imagePath,
        status: bookStatus.value,
      );
      addBook(book);
    } else {
      var book = BookModel(
        name: nameController.text,
        description: descriptionController.text,
        author: authorController.text,
        image: imagePath,
        status: bookStatus.value,
      );
      addBook(book);
    }
    nameController.text = "";
    descriptionController.text = "";
    authorController.text = "";
    imagePath = "";
  }

  void toggleBookStatus(bool status) {
    bookStatus.value = status;
  }
}
