import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'server.dart';

class Client {
  late Socket _socket;
  String sessionId = '';
  List<InputItem> inputItems = [];


  Client({
    required this.inputItems,
  });

  // 서버에 연결
  Future<void> connect( String serverIp, int serverPort) async {
    try {
      print('Connecting to server: $serverIp:$serverPort');
      _socket = await Socket.connect(serverIp, serverPort);
      print('Connected to server: $serverIp:$serverPort');

      _socket.listen((data) {
        _handleConnection(data);
      });

    } catch (e) {
      print('Connection error: $e');
    }
  }

  void onHandshake(Data data){
    sessionId = data.sessionId;
  }

  // 서버로 데이터 전송
  void sendData(Data data) {
    _socket.write(jsonEncode(data.toJson()));
  }

  // 서버로부터 받은 메시지 처리
  void _handleConnection(Uint8List receivedData){
    Data data = Data.fromString(utf8.decode(receivedData));
    if(data.type == FixedProtocol.HANDSHAKE){
      onHandshake(data);
      return;
    }
    for(var item in inputItems){
      if(item.id == data.type.toInt()){
        item.function(SERVER_ID, data);
      }
    }
  }

  // 클라이언트 연결 종료
  void disconnect() {
    _socket.close();
    print('Disconnected from server.');
  }
}