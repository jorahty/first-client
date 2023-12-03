import 'package:flutter/material.dart';
import 'package:flame/components.dart';

class Arena extends PolygonComponent {
  Arena()
      : super(
          [
            Vector2(728, 297),
            Vector2(583, 442),
            Vector2(-570, 442),
            Vector2(-715, 297),
            Vector2(-715, 141),
            Vector2(-894, 141),
            Vector2(-894, -95),
            Vector2(-715, -95),
            Vector2(-715, -535),
            Vector2(-4, -535),
            Vector2(-4, -699),
            Vector2(-1011, -699),
            Vector2(-1011, 677),
            Vector2(996, 677),
            Vector2(996, -699),
            Vector2(16, -699),
            Vector2(16, -535),
            Vector2(728, -535),
            Vector2(728, -95),
            Vector2(906, -95),
            Vector2(906, 141),
            Vector2(728, 141),
          ],
          anchor: Anchor.center,
          paint: Paint()..color = const Color(0xff5a6984),
        );
}
