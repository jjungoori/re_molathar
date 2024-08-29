import 'package:flutter/material.dart';
import 'package:re_morthar/controllers/GameClientController.dart';
import 'package:re_morthar/game/inputHandler.dart';

class ClientPage extends StatelessWidget {
  const ClientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              GameClientController.to.gameClient.value.connect('10.0.2.2', 8080);
            },
            child: Text('Join Server'),
          ),
          ElevatedButton(
            onPressed: () {
              GameClientController.to.gameClient.value.sendInput(GameInputData(
                data: {'type': GameInputType.ACT},
                playerId: GameClientController.to.gameClient.value.client.sessionId
              ));
            },
            child: Text('Open Server'),
          ),
        ]
      ),
    );
  }
}
