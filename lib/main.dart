import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:re_morthar/controllers/GameClientController.dart';
import 'package:re_morthar/controllers/gameServerController.dart';
import 'package:re_morthar/pages/clientPage.dart';
import 'package:re_morthar/pages/pageSelectionPage.dart';
import 'package:re_morthar/pages/serverPage.dart';

void main() {
  Get.put(GameClientController());
  Get.put(GameServerController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: [
        GetPage(name: '/server', page: () => ServerPage()),
        GetPage(name: '/client', page: () => ClientPage()),

      ],
      home: PageSelectionPage(),
    );
  }
}
