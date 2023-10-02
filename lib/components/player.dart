import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';

import '../game.dart';
import '../resources/step_time.dart';

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

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<FlamePixelAdventure>, KeyboardHandler {
  Player({
    this.character = Character.virtualGuy,
    Vector2? position,
  }) : super(position: position);
  final Character character;

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;

  double horizontalMovement = 0;
  double speed = 100;
  Vector2 velocity = Vector2.zero();

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerState();
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

    return false;
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
    velocity.x = horizontalMovement * speed;
    position.x += velocity.x * dt;
  }

  void _updatePlayerState() {
    PlayerState state = PlayerState.idle;

    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    if (velocity.x != 0) state = PlayerState.running;

    current = state;
  }
}
