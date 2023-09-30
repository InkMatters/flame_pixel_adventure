import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'levels/level.dart';
import 'resources/color_palette.dart';

class FlamePixelAdventure extends FlameGame {
  late final CameraComponent camera;
  final level = Level();

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
    return super.onLoad();
  }
}
