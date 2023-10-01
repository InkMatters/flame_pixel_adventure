import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'actors/player.dart';
import 'levels/level.dart';
import 'resources/color_palette.dart';

class FlamePixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  final level = Level(levelName: Levels.levelOne, player: Player());
  late final CameraComponent camera;
  late JoystickComponent joystick;

  @override
  Color backgroundColor() => ColorPalette.background;

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();

    camera = CameraComponent.withFixedResolution(
      world: level,
      width: 640,
      height: 360,
    );
    camera.viewfinder.anchor = Anchor.topLeft;

    addJoyStick();
    await addAll(<Component>[camera, level]);

    return super.onLoad();
  }

  Future<void> addJoyStick() async {
    joystick = JoystickComponent(
      priority: 10,
      margin: const EdgeInsets.only(left: 32, bottom: 32),
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
    await add(joystick);
  }
}
