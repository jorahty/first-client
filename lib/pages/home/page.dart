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
      backgroundColor: Colors.grey,
      body: Column(
        children: [
          Text(isConnected ? 'Searching...' : ''),
          ElevatedButton(
            onPressed: isConnected ? disconnect : connect,
            child: Text(isConnected ? 'Cancel' : 'Play'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _socket.disconnect();
    super.dispose();
  }
}
