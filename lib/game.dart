import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_pixel_adventure/actors/player.dart';
import 'package:flutter/material.dart';

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

    addAll(<Component>[camera, level]);

    addJoyStick();

    return super.onLoad();
  }

  void addJoyStick() {
    joystick = JoystickComponent();
  }
}
