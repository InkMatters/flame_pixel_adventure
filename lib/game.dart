import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'components/level.dart';
import 'components/player.dart';
import 'resources/color_palette.dart';

class FlamePixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  Player player = Player();
  @override
  late final CameraComponent camera;
  late JoystickComponent joystick;
  bool showJoystick = false;

  @override
  Color backgroundColor() => ColorPalette.background;

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();

    final level = Level(
      levelName: Levels.levelTwo,
      player: player,
    );

    if (showJoystick) {
      createJoystick();
    }
    camera = CameraComponent.withFixedResolution(
      world: level,
      width: 640,
      height: 360,
      hudComponents: showJoystick ? [joystick] : null,
    );
    camera.viewfinder.anchor = Anchor.topLeft;

    await addAll(<Component>[camera, level]);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    updateJoystick();
    super.update(dt);
  }

  void createJoystick() {
    joystick = JoystickComponent(
      priority: 10,
      margin: const EdgeInsets.only(left: 1, bottom: 28),
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Knob.png'),
        ),
      ),
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Joystick.png'),
        ),
      ),
    );
  }

  void updateJoystick() {
    if (!showJoystick) {
      return;
    }
    switch (joystick.direction) {
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      default:
        player.horizontalMovement = 0;
        break;
    }
  }
}
