import 'package:get/get.dart';
import 'package:re_morthar/gameConnections/gameServer.dart';

class GameServerController extends GetxController {
  static GameServerController get to => Get.find();
  var gameServer = GameServer().obs;
}