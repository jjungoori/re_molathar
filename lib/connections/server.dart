import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

const String SERVER_ID = '0';
const String NO_SESSION_ID = '-1';

class FixedProtocol{
  static const int HANDSHAKE = 10001;
}

class Protocol{
  static const int GAME_DATA = 0;
  static const int SECRET_DATA = 1;
  static const int GAME_INPUT = 2;
  static const int END = 3;
  static const int REQUEST = 4;

  static const int REGISTER = 100;
}

class Data{
  final int type;
  final Map<String, dynamic> data;
  final String sessionId;

  Data({
    required this.type,
    required this.data,
    this.sessionId = NO_SESSION_ID,
  });

  Data copyWith({
    int? type,
    Map<String, dynamic>? data,
    String? sessionId,
  }) {
    return Data(
      type: type ?? this.type,
      data: data ?? this.data,
      sessionId: sessionId ?? this.sessionId,
    );
  }

  factory Data.fromString(String jsonString){
    Map<String, dynamic> json = jsonDecode(jsonString);
    return Data.fromJson(json);
  }

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      type: json['type'],
      data: json['data'],
      sessionId: json['sessionID']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'type': type,
      'data': data,
      'sessionID': sessionId,
    };
  }
}

class User{
  final String id;
  final String name;

  User({
    required this.id,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'name': name,
    };
  }
}

/* 전송, 수신 데이터 처리 */
class Server{
  ServerSocket? serverSocket;
  Map<String, Socket> sessions = {};
  List<InputItem> inputItems = [];
  Function onConnect = (){};

  Server({
    required this.onConnect,
    required this.inputItems,
  });

  Future<void> startServer(int port) async {
    serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, port);
    print('Server running on port $port');

    serverSocket!.listen((client) {

      onConnect();

      String sessionId = generateSessionId();
      print("the 1 session id is $sessionId");
      sessions[sessionId] = client;
      sendDataToClient(sessionId, Data(
        data: {
          'sessionId': sessionId,
        },
        type: FixedProtocol.HANDSHAKE,
      ));

      _handleConnection(client);
    });
  }

  void sendDataToClient(String sessionId, Data data){
    sessions[sessionId]!.write(jsonEncode(data.copyWith(sessionId: SERVER_ID).toJson()));
  }

  void _handleConnection(Socket client){
    client.listen((receivedData) {
      Data data = Data.fromString(utf8.decode(receivedData));
      if(data.type == FixedProtocol.HANDSHAKE){
        // onHandshake(data);
        return;
      }
      for(var item in inputItems){
        if(item.id == data.type.toInt()){
          item.function(data);
        }
      }
    });
  }
}

class InputItem{
  final int id;
  final Function function; //should be declared with (Data data){~};

  InputItem({
    required this.id,
    required this.function,
  });
}

String generateSessionId() {
  final random = Random();
  final codeUnits = List.generate(20, (index) {
    return random.nextInt(33) + 89;
  });

  return String.fromCharCodes(codeUnits);
}
