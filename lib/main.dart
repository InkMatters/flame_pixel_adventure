import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();

  final FlamePixelAdventure game = FlamePixelAdventure();

  runApp(GameWidget(game: kDebugMode ? FlamePixelAdventure() : game));
}
