import 'dart:async';

import 'package:re_morthar/connections/server.dart';
import 'package:re_morthar/game/inputHandler.dart';
import 'package:re_morthar/game/molthar.dart';

class GameServer implements GameInputObserver{
  List<User> connectedUsers = [];
  Game? game;
  GameInputHandler gameInputHandler = GameInputHandler();

  GameServer(){
    gameInputHandler.addObserver(this);
  }

  void startGame(){
    print("game start");
    var players = connectedUsers.map((user) => Player(user.name, user.id)).toList();
    game = Game(players, gameInputHandler);
    game!.start();
  }

  @override
  void onInputRequested(InputRequest request) {
    server.sendDataToClient(request.playerId, Data(
      type: Protocol.REQUEST,
      data: request.toJson()
    ));
  }

  late Server server = Server(
    inputItems: [
      InputItem(
        id: Protocol.REGISTER,
        function: (Data data) => register(data)
      ),
      InputItem(
        id: Protocol.GAME_INPUT,
        function: (Data data){
          gameInputHandler.handleInput(GameInputData.fromJson(data.data));
        }
      )
    ],
    onConnect: (){
      print('Client connected');
    }
  );
  
  void register(Data data){
    var name = data.data['userName'];
    var id = data.sessionId;
    connectedUsers.add(User(id: id, name: name));

    print('User $name registered');
  }

  void startServer(int port){
    server.startServer(port);
  }
}