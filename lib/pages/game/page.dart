import 'package:flutter/material.dart';

import 'package:flame/game.dart';

// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'socket/uri.dart';
import 'canvas/canvas.dart';
import 'controls/controls.dart';

class GamePage extends StatelessWidget {
  const GamePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xff45406b),
      body: GameBody(),
    );
  }
}

class GameBody extends StatefulWidget {
  const GameBody({super.key});

  @override
  State<GameBody> createState() => _GameBodyState();
}

class _GameBodyState extends State<GameBody> {
  late IO.Socket _socket;
  late CanvasGame _game;

  showError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.orangeAccent),
            SizedBox(width: 10),
            Text('Connection Error'),
          ],
        ),
        duration: Duration(days: 365),
      ),
    );
  }

  hideError() {
    ScaffoldMessenger.of(context).clearSnackBars();
  }

  @override
  void initState() {
    super.initState();

    _socket = IO.io(
      socketUri,
      IO.OptionBuilder().setTransports(['websocket']).build(),
    );

    _socket.onConnectError((msg) => showError());
    _socket.onError((msg) => showError());
    _socket.onConnect((_) => hideError());

    _game = CanvasGame(sendAngle: (angle) => _socket.emit('a', angle));
    _socket.on('move', _game.onMove);
    _socket.on('side', _game.assignSide);
  }

  @override
  void deactivate() {
    _socket.disconnect();
    _socket.dispose();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ClipRect(
            child: GameWidget(
              game: _game,
              loadingBuilder: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
        Controls(socket: _socket),
      ],
    );
  }
}
