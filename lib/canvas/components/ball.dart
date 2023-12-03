import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Ball extends CircleComponent {
  Ball()
      : super(
          radius: 40,
          anchor: Anchor.center,
          paint: Paint()..color = const Color(0xffc4b3d9),
        );
}
