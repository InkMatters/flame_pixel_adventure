import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';

class CollisionBlock extends PositionComponent {
  CollisionBlock({
    required Vector2 position,
    required Vector2 size,
    this.isPlatform = false,
  }) : super(position: position, size: size) {
    if (kDebugMode) {
      debugMode = true;
    }
  }

  bool isPlatform;
}
