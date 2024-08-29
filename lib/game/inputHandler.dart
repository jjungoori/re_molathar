import 'dart:async';

import 'package:re_morthar/connections/server.dart';
class GameInputHandler {
  Map<String, Completer<GameInputData>> pendingRequests = {}; // 플레이어 ID별로 응답을 기다리는 Completer 맵
  List<GameInputObserver> observers = []; // 옵저버 리스트

  // 옵저버 추가 메서드
  void addObserver(GameInputObserver observer) {
    observers.add(observer);
  }

  // 옵저버 제거 메서드
  void removeObserver(GameInputObserver observer) {
    observers.remove(observer);
  }

  void handleInput(GameInputData data) {
    final playerId = data.playerId;
    if (pendingRequests.containsKey(playerId)) {
      pendingRequests[playerId]!.complete(data);
      pendingRequests.remove(playerId);
    }
  }

  Future<GameInputData> requestInput(InputRequest request) {
    Completer<GameInputData> completer = Completer<GameInputData>();
    pendingRequests[request.playerId] = completer;

    // 옵저버들에게 이벤트 알림
    for (var observer in observers) {
      observer.onInputRequested(request);
    }

    return completer.future;
  }
}


abstract class GameInputObserver {
  void onInputRequested(InputRequest request);
}


// 외부에서 들어온 입력 타입
class GameInputData{
  final String playerId;
  final Map<String, dynamic> data;

  GameInputData({
    this.playerId = 'none',
    required this.data,
  });

  //copyWith
  GameInputData copyWith({
    String? playerId,
    Map<String, dynamic>? data,
  }) {
    return GameInputData(
      playerId: playerId ?? this.playerId,
      data: data ?? this.data,
    );
  }

  factory GameInputData.fromJson(Map<String, dynamic> json){
    return GameInputData(
      playerId: json['playerId'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'playerId': playerId,
      'data': data,
    };
  }
}

//Game에서 데이터를 요청할때 사용
class InputRequest{
  final String playerId;
  final int inputType;

  InputRequest({
    required this.playerId,
    required this.inputType,
  });

  factory InputRequest.fromJson(Map<String, dynamic> json){
    return InputRequest(
      playerId: json['playerId'],
      inputType: json['inputType'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'playerId': playerId,
      'inputType': inputType,
    };
  }
}

class GameInputType{
  static const int ACT = 0;
}