import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_pixel_adventure/resources/step_time.dart';

import '../game.dart';

enum Character {
  maskDude('MaskDude'),
  ninjaFrog('NinjaFrog'),
  pinkMan('PinkMan'),
  virtualGuy('VirtualGuy');

  const Character(this.fileName);
  final String fileName;
}

enum PlayerState {
  idle('Idle', 11),
  running('Run', 12);

  const PlayerState(this.fileName, this.seqAmount);
  final String fileName;
  final int seqAmount;
}

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<FlamePixelAdventure> {
  Player({
    required this.character,
  });
  final Character character;

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    return super.onLoad();
  }

  void _loadAllAnimations() {
    idleAnimation = _generateAnimation(state: PlayerState.idle);
    runningAnimation = _generateAnimation(state: PlayerState.running);

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
    };

    current = PlayerState.running;
  }

  SpriteAnimation _generateAnimation({
    required PlayerState state,
  }) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache(
          'MainCharacters/${character.fileName}/${state.fileName} (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: state.seqAmount,
        stepTime: StepTime.character,
        textureSize: Vector2.all(32),
      ),
    );
  }
}
