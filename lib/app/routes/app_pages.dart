import 'package:get/get.dart';
import '../screens/app_introduction/introduction.dart';
import '../screens/app_login/login_screen.dart';
import '../screens/app_signup/signup_screen.dart';
import '../screens/app_splash/splash_screen.dart';
import '../screens/book_chat/book_chat_screen.dart';
import '../screens/book_chat/book_chat_users.dart';
import '../screens/books/add_book_screen.dart';
import '../screens/books/book_detail_screen.dart';
import '../screens/books/book_list_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final List<GetPage> pages = <GetPage>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.introduction,
      page: () => const AppIntroScreen(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignUpScreen(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const Login(),
    ),
    GetPage(
      name: AppRoutes.bookListScreen,
      page: () => const ProductListScreen(),
    ),
    GetPage(
      name: AppRoutes.addBookScreen,
      page: () => const AddBookScreen(),
    ),
    GetPage(
      name: AppRoutes.bookDetailScreen,
      page: () => const BookDetailScreen(),
    ),
    GetPage(
      name: AppRoutes.bookChatUsersScreen,
      page: () =>  const ChatUserScreen(),
    ),  GetPage(
      name: AppRoutes.bookChatScreen,
      page: () =>  const ChatRoom(),
    ),

  ];
}
