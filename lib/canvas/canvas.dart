import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'components/ball.dart';
import 'components/player.dart';
import 'components/arena.dart';

class CanvasGame extends FlameGame with MouseMovementDetector {
  CanvasGame({required this.sendAngle});

  final void Function(String) sendAngle;

  late Ball ball;
  late Player leftPlayer;
  late Player rightPlayer;
  late Player myPlayer;
  late CameraComponent cameraComponent;

  @override
  Color backgroundColor() => const Color(0xff3a4260);

  @override
  Future<void> onLoad() async {
    final world = World();
    cameraComponent = CameraComponent(world: world)
      ..viewport.position.y = -40
      ..viewfinder.zoom = 0.5;
    addAll([world, cameraComponent]);

    ball = Ball()..y = 1000;
    leftPlayer = Player(color: const Color(0xff49a581))..y = 1000;
    rightPlayer = Player(color: const Color(0xff6f8ae4))..y = 1000;
    myPlayer = leftPlayer;

    world.addAll([Arena(), ball, leftPlayer, rightPlayer]);
  }

  void onMove(data) {
    final poses = data.map((i) => i.toDouble()).toList();

    leftPlayer.position.setValues(poses[0], poses[1]);
    leftPlayer.angle = poses[2];
    rightPlayer.position.setValues(poses[3], poses[4]);
    rightPlayer.angle = poses[5];
    ball.position.setValues(poses[6], poses[7]);
    ball.angle = poses[8];

    // move camera
    double target = (myPlayer == leftPlayer ? poses[0] : poses[3]) *
        -cameraComponent.viewfinder.zoom;
    double current = cameraComponent.viewport.position.x;
    cameraComponent.viewport.position.x = current + (target - current) * 0.1;

    // camera zoom
    // final distance = myPlayer.position.distanceTo(ball.position);
    // double targetZoom = -0.0001 * distance + 0.6;
    // double currentZoom = cameraComponent.viewfinder.zoom;
    // cameraComponent.viewfinder.zoom =
    //     currentZoom + (targetZoom - currentZoom) * 0.1;
  }

  void assignSide(side) {
    myPlayer = (side == 'left' ? leftPlayer : rightPlayer);
  }

  @override
  void onMouseMove(PointerHoverInfo info) {
    final screenCenter = Vector2(
      -cameraComponent.viewport.position.x / cameraComponent.viewfinder.zoom,
      -cameraComponent.viewport.position.y / cameraComponent.viewfinder.zoom,
    );

    final inGameMousePosition = screenCenter -
        canvasSize +
        info.eventPosition.game / cameraComponent.viewfinder.zoom;

    final diff = inGameMousePosition - myPlayer.position;
    final angle = diff.screenAngle();

    sendAngle(angle.toStringAsFixed(3));
  }
}
