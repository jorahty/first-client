import 'package:flutter/material.dart';
import 'package:flame/game.dart';

// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'canvas/canvas.dart';
import 'controls/controls.dart';
import 'package:toolmax/widgets/countdown.dart';

class GamePage extends StatelessWidget {
  final String socketUri; // Add a parameter for socketUri

  const GamePage({
    Key? key,
    required this.socketUri,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff45406b),
      body: GameBody(socketUri: socketUri), // Pass socketUri to GameBody
    );
  }
}

class GameBody extends StatefulWidget {
  final String socketUri; // Add a parameter for socketUri

  const GameBody({
    Key? key,
    required this.socketUri,
  }) : super(key: key);

  @override
  State<GameBody> createState() => _GameBodyState();
}

class _GameBodyState extends State<GameBody> {
  late IO.Socket _socket;
  late CanvasGame _game;

  DateTime? deadline;

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
      widget.socketUri,
      IO.OptionBuilder().setTransports(['websocket']).build(),
    );

    _socket.onConnectError((msg) => showError());
    _socket.onError((msg) => showError());
    _socket.onConnect((_) => hideError());

    _socket.on('deadline', (str) {
      setState(() {
        deadline = DateTime.parse(str);
      });
    });

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
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Column(
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
        ),
        Positioned(
          top: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
              color: Color(0xff5a6984),
            ),
            child: Builder(builder: (context) {
              return deadline != null
                  ? Countdown(deadline: deadline!)
                  : const SizedBox.shrink();
            }),
          ),
        ),
      ],
    );
  }
}
