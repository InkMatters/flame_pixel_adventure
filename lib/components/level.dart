import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_pixel_adventure/components/collision_bloc.dart';
import 'package:flame_tiled/flame_tiled.dart';

import 'player.dart';

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
  late JoystickComponent joystickComponent;
  List<CollisionBlock> collisionBlocks = <CollisionBlock>[];

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load(levelName, Vector2.all(16));
    add(level);

    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('SpawnPoints');

    if (spawnPointsLayer != null) {
      for (final TiledObject object in spawnPointsLayer.objects) {
        switch (object.class_) {
          case 'Player':
            player.position = Vector2(object.x, object.y);
            add(player);
            break;
          default:
            break;
        }
      }
    }
    final collisions = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if (collisions != null) {
      for (final TiledObject object in collisions.objects) {
        switch (object.class_) {
          case 'Platform':
            final platform = (CollisionBlock(
              position: Vector2(object.x, object.y),
              size: Vector2(object.width, object.height),
              isPlatform: true,
            ));
            collisionBlocks.add(platform);
            add(platform);
            break;
          default:
            final collisionBlock = CollisionBlock(
              position: Vector2(object.x, object.y),
              size: Vector2(object.width, object.height),
            );
            collisionBlocks.add(collisionBlock);
            add(collisionBlock);
            break;
        }
      }
    }

    return super.onLoad();
  }
}
