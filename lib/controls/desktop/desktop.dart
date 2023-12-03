import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

class DesktopControls extends StatelessWidget {
  const DesktopControls({super.key, required this.socket});

  final IO.Socket socket;

  void onKeyEvent(KeyEvent event) {
    if (event.logicalKey != LogicalKeyboardKey.space) return;

    if (event is KeyDownEvent) {
      socket.emit('b');
    } else if (event is KeyUpEvent) {
      socket.emit('B');
    }
  }

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();
    FocusScope.of(context).requestFocus(focusNode);

    return KeyboardListener(
      focusNode: focusNode,
      onKeyEvent: onKeyEvent,
      child: const SizedBox.shrink(),
    );
  }
}
