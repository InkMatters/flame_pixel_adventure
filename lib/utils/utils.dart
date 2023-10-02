import 'package:flame_pixel_adventure/components/collision_bloc.dart';
import 'package:flame_pixel_adventure/components/player.dart';

bool checkCollision(Player player, CollisionBlock block) {
  final double playerX = player.position.x;
  final double playerY = player.position.y;
  final double playerWidth = player.width;
  final double playerHeight = player.height;

  final double blockX = block.position.x;
  final double blockY = block.position.y;
  final double blockWidth = block.width;
  final double blockHeight = block.height;

  final double fixedX = player.scale.x < 0 ? playerX - playerWidth : playerX;

  return (playerY < blockY + blockHeight &&
      playerY + playerHeight > blockY &&
      fixedX < blockX + blockWidth &&
      fixedX + playerWidth > blockX);
}
