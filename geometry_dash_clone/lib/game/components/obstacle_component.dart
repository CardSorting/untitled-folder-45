import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import '../../config/game_config.dart';
import '../core/game_engine.dart';

/// Obstacle component with collision detection and movement
class ObstacleComponent extends PositionComponent with HasGameRef<GameEngine>, CollisionCallbacks {
  final double speed;
  bool _hasPassedPlayer = false;
  late final PolygonComponent _obstacleSprite;
  late final PolygonHitbox hitbox;

  ObstacleComponent({
    required Vector2 position,
    required Vector2 size,
    required this.speed,
  }) : super(
         position: position,
         size: size,
       );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Create triangle shape vertices
    final vertices = [
      Vector2(0, size.y),          // Bottom left
      Vector2(size.x / 2, 0),      // Top middle
      Vector2(size.x, size.y),     // Bottom right
    ];

    // Add visual representation
    _obstacleSprite = PolygonComponent(
      vertices,
      paint: Paint()..color = Color(GameConfig.obstacleColor),
      children: [
        MoveEffect.by(
          Vector2(0, -2),
          EffectController(
            duration: 1,
            reverseDuration: 1,
            infinite: true,
            curve: Curves.easeInOut,
          ),
        ),
      ],
    );
    add(_obstacleSprite);

    // Add collision detection
    hitbox = PolygonHitbox(vertices);
    add(hitbox);
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Move obstacle to the left
    position.x -= speed * dt;

    // Check if passed player to increment score
    if (!_hasPassedPlayer && position.x < 100 - size.x) { // 100 is player x position
      _hasPassedPlayer = true;
      gameRef.stateController.incrementScore();
    }

    // Remove if off screen
    if (position.x < -size.x) {
      removeFromParent();
    }
  }

  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // Add visual feedback for collision
    add(
      OpacityEffect.fadeOut(
        EffectController(duration: 0.1),
      )..onComplete = () {
        removeFromParent();
      },
    );
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    
    if (other is RectangleHitbox) {
      gameRef.stateController.gameOver();
      onCollision(intersectionPoints, other);
    }
  }
}
