import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_pixel_adventure/actors/player.dart';
import 'package:flame_tiled/flame_tiled.dart';

mixin Levels {
  static const String levelOne = 'level-01.tmx';
  static const String levelTwo = 'level-02.tmx';
}

class Level extends World {
  Level({
    required this.levelName,
    required this.player,
  });
  final String levelName;
  final Player player;

  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load(levelName, Vector2.all(16));
    add(level);

    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('SpawnPoints');

    for (final TiledObject spawnPoint in spawnPointsLayer?.objects ?? []) {
      switch (spawnPoint.class_) {
        case 'Player':
          player.position = Vector2(spawnPoint.x, spawnPoint.y);
          add(player);
          break;
        default:
          break;
      }
    }
    return super.onLoad();
  }
}
