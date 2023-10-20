import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_library/app/app_widget/app_debug_widget/debug_pointer.dart';
import '../model/book_chat_user_model.dart';

class BookChatUserController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxList<BookChatUserModel> users = <BookChatUserModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final querySnapshot = await firestore.collection('users').get();
      final usersList = querySnapshot.docs.map((doc) {
        final data = doc.data();
        final uid = doc.id;
        final name = data['name'] as String?;
        final email = data['email'] as String?;

        // Perform additional null checks or default value assignments as needed

        return BookChatUserModel(
          uid: uid,
          displayName: name ?? 'No Name',
          email: email ?? 'No Email',
          // Add more fields as needed
        );
      }).toList();
      users.assignAll(usersList);
    } catch (e) {
      Debug.log('Error fetching users: $e');
    }
  }

}
