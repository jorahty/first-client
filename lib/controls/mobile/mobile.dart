import 'package:flutter/material.dart';

// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'touch/dial.dart';
import 'touch/boost.dart';

class MobileControls extends StatelessWidget {
  const MobileControls({
    super.key,
    required this.socket,
  });

  final IO.Socket socket;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Dial(socket: socket),
            const SizedBox(width: 20),
            Expanded(child: BoostButton(socket: socket)),
          ],
        ),
      ),
    );
  }
}
