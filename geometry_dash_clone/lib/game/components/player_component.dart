import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import '../../config/game_config.dart';
import '../core/game_engine.dart';
import '../state/game_state_controller.dart';

/// Player character component with physics and collision detection
class PlayerComponent extends PositionComponent with HasGameRef<GameEngine>, CollisionCallbacks {
  double _verticalVelocity = 0.0;
  bool _isOnGround = false;
  bool _isDead = false;
  late final RectangleHitbox hitbox;
  late final ShapeHitbox collisionBox;
  late final RectangleComponent _playerSprite;

  PlayerComponent()
      : super(
          size: Vector2(GameConfig.playerSize, GameConfig.playerSize),
          position: Vector2(100, 0),
          anchor: Anchor.bottomLeft,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Add visual representation
    _playerSprite = RectangleComponent(
      size: size,
      paint: Paint()..color = Color(GameConfig.playerColor),
    );
    add(_playerSprite);

    // Add idle animation
    _playerSprite.add(
      ScaleEffect.by(
        Vector2.all(1.1),
        EffectController(
          duration: 0.5,
          reverseDuration: 0.5,
          infinite: true,
          curve: Curves.easeInOut,
        ),
      ),
    );

    // Add collision detection
    hitbox = RectangleHitbox(
      size: Vector2(size.x * 0.8, size.y * 0.8), // Slightly smaller than visual size
      position: Vector2(size.x * 0.1, size.y * 0.1), // Centered within sprite
    );
    add(hitbox);

    // Add collision box for obstacle detection
    collisionBox = RectangleHitbox(
      size: Vector2(size.x * 0.8, size.y * 0.8),
      position: Vector2(size.x * 0.1, size.y * 0.1),
      collisionType: CollisionType.active,
    );
    add(collisionBox);
  }

  void jump() {
    if (_isOnGround && !_isDead) {
      _verticalVelocity = GameConfig.jumpForce;
      _isOnGround = false;
      
      // Add jump effect
      scale = Vector2.all(0.8);
      add(
        ScaleEffect.to(
          Vector2.all(1.0),
          EffectController(
            duration: 0.2,
            curve: Curves.easeOut,
          ),
        ),
      );
    }
  }

  void die() {
    if (!_isDead) {
      _isDead = true;
      add(
        RotateEffect.by(
          3.14, // 180 degrees
          EffectController(
            duration: 0.5,
            curve: Curves.easeInOut,
          ),
        ),
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    if (_isDead) return;

    // Apply gravity
    _verticalVelocity += GameConfig.gravity * dt;
    
    // Update position
    position.y += _verticalVelocity * dt;

    // Ground collision check
    final groundY = gameRef.size.y - GameConfig.groundHeight;
    if (position.y > groundY) {
      position.y = groundY;
      _verticalVelocity = 0;
      _isOnGround = true;
    }

    // Rotation based on velocity
    if (!_isOnGround) {
      angle = _verticalVelocity * 0.001; // Subtle rotation effect
    } else {
      angle = 0;
    }
  }

  void reset() {
    _isDead = false;
    _verticalVelocity = 0.0;
    position = Vector2(100, gameRef.size.y - GameConfig.groundHeight);
    angle = 0;
    scale = Vector2.all(1.0);
  }
}
