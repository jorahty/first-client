import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

class BoostButton extends StatefulWidget {
  const BoostButton({super.key, required this.socket});

  final IO.Socket socket;

  @override
  State<BoostButton> createState() => _BoostButtonState();
}

class _BoostButtonState extends State<BoostButton> {
  var isBoosting = false;

  startBoost() {
    widget.socket.emit('b');
    HapticFeedback.lightImpact();
    setState(() {
      isBoosting = true;
    });
  }

  stopBoost() {
    widget.socket.emit('B');
    HapticFeedback.lightImpact();
    setState(() {
      isBoosting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => startBoost(),
      onTapUp: (_) => stopBoost(),
      onTapCancel: stopBoost,
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          color: isBoosting ? const Color(0xff49a581) : const Color(0xff6f8ae4),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: Text(
            'B',
            style: TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
