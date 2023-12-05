import 'dart:async';
import 'package:flutter/material.dart';

// Usage:
// Countdown(deadline: DateTime.parse('2023-12-04T04:29:34.396Z'))

class Countdown extends StatefulWidget {
  final DateTime? deadline;

  const Countdown({super.key, required this.deadline});

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  late Timer timer;
  late Duration remainingTime;

  @override
  void initState() {
    super.initState();
    updateTimer();
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => updateTimer(),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void updateTimer() {
    setState(() {
      remainingTime = widget.deadline != null
          ? widget.deadline!.difference(DateTime.now())
          : const Duration();
    });
  }

  @override
  Widget build(BuildContext context) {
    int minutes = remainingTime.inMinutes;
    int seconds = remainingTime.inSeconds % 60;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$minutes:${seconds.toString().padLeft(2, '0')}',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
