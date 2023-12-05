import 'package:flutter/material.dart';
import 'package:flame/game.dart';

// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'canvas/canvas.dart';
import 'controls/controls.dart';
import 'package:toolmax/widgets/countdown.dart';

class GamePage extends StatelessWidget {
  final String socketUri;

  const GamePage({
    Key? key,
    required this.socketUri,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff45406b),
      body: GameBody(socketUri: socketUri),
    );
  }
}

class GameBody extends StatefulWidget {
  final String socketUri;

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

  DateTime? _deadline;

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

  endMatch() {
    _socket.disconnect();
    setState(() => _deadline = null);

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                'Match Ended!',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 40,
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color(0xff6f8ae4)),
                    padding: const EdgeInsets.all(15),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 40,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
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
      final deadlinee = DateTime.parse(str);
      setState(() => _deadline = deadlinee);
      final timeUntilDeadline = deadlinee.difference(DateTime.now());
      Future.delayed(timeUntilDeadline, endMatch);
      endMatch();
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
          child: Banner(deadline: _deadline),
        ),
      ],
    );
  }
}

class Banner extends StatelessWidget {
  const Banner({
    super.key,
    required this.deadline,
  });

  final DateTime? deadline;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          '2',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Color(0xff49a581),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
            color: Color(0xff5a6984),
          ),
          child: Countdown(deadline: deadline),
        ),
        const SizedBox(width: 10),
        const Text(
          '3',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Color(0xff6f8ae4),
          ),
        ),
      ],
    );
  }
}
