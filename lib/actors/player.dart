import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_pixel_adventure/resources/step_time.dart';

import '../game.dart';

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<FlamePixelAdventure> {
  late final SpriteAnimation idleAnimation;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    return super.onLoad();
  }

  void _loadAllAnimations() {
    idleAnimation = SpriteAnimation.fromFrameData(
      game.images.fromCache('MainCharacters/NinjaFrog/Idle (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: 11,
        stepTime: StepTime.idle,
        textureSize: Vector2.all(32),
      ),
    );
  }
}
