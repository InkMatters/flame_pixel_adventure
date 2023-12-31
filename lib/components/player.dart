import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_pixel_adventure/components/collision_bloc.dart';
import 'package:flame_pixel_adventure/components/player_hitbox.dart';
import 'package:flame_pixel_adventure/utils/utils.dart';
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
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation fallingAnimation;

  final double _gravity = 9.8;
  final double _jumpForce = 250;
  final double _terminalVelocity = 250;

  double horizontalMovement = 0;
  double speed = 100;
  Vector2 velocity = Vector2.zero();

  bool isOnGround = false;
  bool hasJumped = false;
  List<CollisionBlock> collisionBlocks = <CollisionBlock>[];
  PlayerHitbox hitbox = PlayerHitbox(
    offsetX: 10,
    offsetY: 4,
    width: 14,
    height: 28,
  );

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    debugMode = true;

    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height),
    ));

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerState();
    _updatePlayerMovement(dt);
    _checkHorizontalCollisions();
    _applyGravity(dt);
    _checkVerticalCollisions();
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

    hasJumped = keysPressed.contains(LogicalKeyboardKey.space);

    return false;
  }

  void _loadAllAnimations() {
    idleAnimation = _generateAnimation(state: PlayerState.idle);
    runningAnimation = _generateAnimation(state: PlayerState.running);
    jumpingAnimation = _generateAnimation(state: PlayerState.jump);
    fallingAnimation = _generateAnimation(state: PlayerState.fall);

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.jump: jumpingAnimation,
      PlayerState.fall: fallingAnimation,
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
    if (hasJumped && isOnGround) {
      _playerJump(dt);
    }
    if (velocity.y > _gravity) {
      isOnGround = false;
    }
    velocity.x = horizontalMovement * speed;
    position.x += velocity.x * dt;
  }

  void _playerJump(double dt) {
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    isOnGround = false;
    hasJumped = false;
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    if (velocity.x > 0 || velocity.x < 0) playerState = PlayerState.running;

    if (velocity.y > 0) playerState = PlayerState.fall;

    if (velocity.y < 0) playerState = PlayerState.jump;

    current = playerState;
  }

  void _checkHorizontalCollisions() {
    for (final block in collisionBlocks) {
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - hitbox.offsetX - hitbox.width;
            break;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + hitbox.width + hitbox.offsetX;
            break;
          }
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _checkVerticalCollisions() {
    for (final block in collisionBlocks) {
      if (block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
        }
      } else {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height - hitbox.offsetY;
          }
        }
      }
    }
  }
}
