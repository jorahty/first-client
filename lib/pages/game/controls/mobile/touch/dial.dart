import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Dial extends StatefulWidget {
  const Dial({super.key, required this.socket});

  final IO.Socket socket;

  @override
  State<Dial> createState() => _DialState();
}

class _DialState extends State<Dial> {
  var isActive = false;
  var dialPosition = 12.0;

  onVerticalDragStart(_) {
    HapticFeedback.lightImpact();
    setState(() {
      isActive = true;
    });
  }

  onVerticalDragEnd(_) {
    HapticFeedback.lightImpact();
    setState(() {
      isActive = false;
    });
  }

  onVerticalDragUpdate(DragUpdateDetails details) {
    widget.socket.emit('r', (details.delta.dy / 50).toStringAsFixed(3));
    setState(() {
      dialPosition += details.delta.dy;
    });
  }

  double wrapAround(double x, int min, int max) {
    if (x < 0) return min + max - ((0 - x).abs() % max);
    return min + (x % max);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: onVerticalDragStart,
      onVerticalDragEnd: onVerticalDragEnd,
      onVerticalDragUpdate: onVerticalDragUpdate,
      child: Container(
        height: 250,
        width: 100,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xff49a581) : const Color(0xff6f8ae4),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: List.generate(7, (index) {
            return Positioned(
              top: wrapAround(dialPosition + 30 * index, 20 - 3, 210 - 3),
              left: 25,
              child: const DialKnob(),
            );
          }),
        ),
      ),
    );
  }
}

class DialKnob extends StatelessWidget {
  const DialKnob({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 12,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
    );
  }
}
