import 'package:re_morthar/connections/server.dart';

class GameServer{
  List<User> connectedUsers = [];

  late Server server = Server(
    inputItems: [
      InputItem(
        id: Protocol.REGISTER,
        function: (Data data) => register(data)
      ),
    ],
    onConnect: (){
      print('Client connected');
    }
  );
  
  void register(Data data){
    var name = data.data['userName'];
    var id = data.sessionId;
    connectedUsers.add(User(id: id, name: name));
  }

  void startServer(int port){
    server.startServer(port);
  }
}