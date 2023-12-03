import 'package:flutter/material.dart';
import 'package:toolmax/pages/game/page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff3a4260),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => const GamePage(
                  socketUri: 'http://138.197.216.1:7202',
                ),
              ),
            );
          },
          child: const Text('Play'),
        ),
      ),
    );
  }
}
