/*GameConnections에는 Game 클래스에 대한 비동기 입출력과 소켓 서버를 연결해주는 클래스인
GameClient와 GameServer가 정의되어 있음.*/


import 'package:re_morthar/connections/client.dart';
import 'package:re_morthar/connections/server.dart';
import 'package:re_morthar/game/inputHandler.dart';

class GameClient{
  late Client client = Client(
    inputItems: [
      InputItem(
        id: Protocol.REQUEST,
        function: (Data data){
          var a = InputRequest.fromJson(data.data);
          print('Request received: ${a.inputType}');
        }
      )
    ],
    onInit: (Data data){
      register();
    }
  );

  void register(){
    client.sendData(Data(type: Protocol.REGISTER, data:  {'userName': 'User'}));
  }

  void connect(String serverIp, int serverPort){
    client.connect(serverIp, serverPort);
  }

  void sendInput(GameInputData data){
    var a = data.copyWith(playerId: client.getSessionId());
    client.sendData(Data(type: Protocol.GAME_INPUT, data: a.toJson()));
  }
}