import 'package:flutter/material.dart';
import 'package:re_morthar/controllers/gameServerController.dart';

class ServerPage extends StatelessWidget {
  const ServerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Server Page'),
          ElevatedButton(
            onPressed: () {
              GameServerController.to.gameServer.value.startServer(8080);
            },
            child: Text('Lobby'),
          ),
          ElevatedButton(
            onPressed: () {
              GameServerController.to.gameServer.value.startGame();
            },
            child: Text('Start Game'),
          ),
        ],
      )
    );
  }
}
