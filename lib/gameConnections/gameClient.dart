/*GameConnections에는 Game 클래스에 대한 비동기 입출력과 소켓 서버를 연결해주는 클래스인
GameClient와 GameServer가 정의되어 있음.*/


import 'package:re_morthar/connections/client.dart';

class GameClient{
  late Client client = Client(
    inputItems: [

    ]
  );

  void connect(String serverIp, int serverPort){
    client.connect(serverIp, serverPort);
  }
}