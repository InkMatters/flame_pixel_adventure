import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'game.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  final FlamePixelAdventure game = FlamePixelAdventure();

  runApp(GameWidget(game: kDebugMode ? FlamePixelAdventure() : game));
}
