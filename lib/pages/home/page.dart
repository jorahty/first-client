import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'package:toolmax/pages/game/page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late io.Socket _socket;

  bool isConnected = false;

  connect() {
    _socket = io.io(
      'http://68.183.248.228:4000/',
      io.OptionBuilder().setTransports(['websocket']).build(),
    );

    setState(() => isConnected = true);

    _socket.on('invite', handleInvite);
  }

  disconnect() {
    _socket.disconnect();

    setState(() => isConnected = false);
  }

  void handleInvite(dynamic invite) {
    disconnect();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => GamePage(
          socketUri: 'http://${invite[0]}:${invite[1]}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff3a4260),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              isConnected ? 'Searching for another player...' : '',
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 40,
              ),
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: isConnected ? disconnect : connect,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: isConnected
                        ? const Color(0xffD0666D)
                        : const Color(0xff6f8ae4),
                  ),
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    isConnected ? 'Cancel' : 'Play',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 40,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _socket.disconnect();
    super.dispose();
  }
}
