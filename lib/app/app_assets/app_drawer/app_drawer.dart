import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/preferences.dart';
import '../app_colors/my_colors.dart';
import '../my_images.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: MyColors.primary,
            ),
            padding: const EdgeInsets.only(
              bottom: 16,
              top: 6,
              right: 8,
              left: 16,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 0,
                  child: Image.asset(
                    MyImages.logo,
                    height: 100,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              // Handle home navigation
            },
            trailing: const Icon(
              Icons.arrow_forward_ios_outlined,
              size: 16,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // Handle settings navigation
            },
            trailing: const Icon(
              Icons.arrow_forward_ios_outlined,
              size: 16,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.login_outlined),
            title: const Text('Logout'),
            onTap: () {
              Get.find<Preferences>().logout();
            },
            trailing: const Icon(
              Icons.arrow_forward_ios_outlined,
              size: 16,
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
