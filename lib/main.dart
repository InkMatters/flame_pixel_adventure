import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_pixel_adventure/levels/level.dart';
import 'package:flame_pixel_adventure/resources/color_palette.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();

  final FlamePixelAdventure game = FlamePixelAdventure();

  runApp(GameWidget(game: kDebugMode ? FlamePixelAdventure() : game));
}

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
