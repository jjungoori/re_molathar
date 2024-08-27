import 'package:get/get.dart';
import 'package:re_morthar/gameConnections/gameClient.dart';

class GameClientController extends GetxController {
  static GameClientController get to => Get.find();
  var gameClient = GameClient().obs;
}