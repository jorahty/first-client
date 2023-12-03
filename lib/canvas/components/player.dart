import 'package:flutter/material.dart';
import 'package:flame/components.dart';

class Player extends RectangleComponent {
  Player({required Color color})
      : super(
          size: Vector2(40, 80),
          anchor: Anchor.center,
          paint: Paint()..color = color,
        );
}
