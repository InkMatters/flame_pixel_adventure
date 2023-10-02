import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import '../resources/step_time.dart';

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
  doubleJump('Double Jump', 6),
  jump('Jump', 1),
  fall('Fall', 1),
  hit('Hit', 7),
  wallJump('Wall Jump', 5),
  running('Run', 12);

  const PlayerState(this.fileName, this.seqAmount);
  final String fileName;
  final int seqAmount;
}

enum PlayerDirection { left, right, none }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<FlamePixelAdventure>, KeyboardHandler {
  Player({
    this.character = Character.virtualGuy,
    Vector2? position,
  }) : super(position: position);
  final Character character;

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;

  PlayerDirection direction = PlayerDirection.none;
  double speed = 100;
  Vector2 velocity = Vector2.zero();
  bool isFacingRight = true;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    if (isLeftKeyPressed && isRightKeyPressed) {
      direction = PlayerDirection.none;
    } else if (isLeftKeyPressed) {
      direction = PlayerDirection.left;
    } else if (isRightKeyPressed) {
      direction = PlayerDirection.right;
    } else {
      direction = PlayerDirection.none;
    }

    return super.onKeyEvent(event, keysPressed);
  }

  void _loadAllAnimations() {
    idleAnimation = _generateAnimation(state: PlayerState.idle);
    runningAnimation = _generateAnimation(state: PlayerState.running);

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
    };

    current = PlayerState.idle;
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

  void _updatePlayerMovement(double dt) {
    double directionX = 0.0;

    switch (direction) {
      case PlayerDirection.left:
        if (isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        directionX -= speed;
        current = PlayerState.running;
        break;
      case PlayerDirection.right:
        if (!isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = true;
        }
        directionX += speed;
        current = PlayerState.running;
        break;
      case PlayerDirection.none:
      default:
        current = PlayerState.idle;
        break;
    }

    velocity = Vector2(directionX, 0.0);
    position += velocity * dt;
  }
}
