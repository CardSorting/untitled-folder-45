import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../config/game_config.dart';
import '../components/background_component.dart';
import '../components/obstacle_component.dart';
import '../geometry_dash_game.dart';

class GameWorld extends Component with HasGameRef<GeometryDashGame> {
  double _timeSinceLastSpawn = 0.0;
  final Random _random = Random();
  late final Timer _difficultyTimer;
  double _currentSpeed;
  double _currentSpawnInterval;
  late final BackgroundComponent _background;

  GameWorld() : 
    _currentSpeed = GameConfig.obstacleSpeed,
    _currentSpawnInterval = GameConfig.obstacleSpawnInterval {
    _difficultyTimer = Timer(
      10,
      onTick: _increaseDifficulty,
      repeat: true,
    );
  }

  @override
  Future<void> onLoad() async {
    // Add scrolling background
    _background = BackgroundComponent();
    add(_background);

    // Add ground
    add(
      RectangleComponent(
        position: Vector2(0, gameRef.size.y - GameConfig.groundHeight),
        size: Vector2(gameRef.size.x, GameConfig.groundHeight),
        paint: Paint()..color = Color(GameConfig.groundColor),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timeSinceLastSpawn += dt;
    _difficultyTimer.update(dt);

    if (_timeSinceLastSpawn >= _currentSpawnInterval) {
      _spawnObstacle();
      _timeSinceLastSpawn = 0.0;
    }
  }

  void _spawnObstacle() {
    final height = _random.nextDouble() * 
        (GameConfig.maxObstacleHeight - GameConfig.minObstacleHeight) + 
        GameConfig.minObstacleHeight;
        
    final obstacle = ObstacleComponent(
      position: Vector2(
        gameRef.size.x,
        gameRef.size.y - GameConfig.groundHeight - height,
      ),
      size: Vector2(30, height),
    );
    add(obstacle);
  }

  void _increaseDifficulty() {
    _currentSpeed *= 1.1; // Increase speed by 10%
    _currentSpawnInterval *= 0.9; // Decrease spawn interval by 10%
  }

  void reset() {
    _currentSpeed = GameConfig.obstacleSpeed;
    _currentSpawnInterval = GameConfig.obstacleSpawnInterval;
    _timeSinceLastSpawn = 0.0;
    children.whereType<ObstacleComponent>().forEach((obstacle) => obstacle.removeFromParent());
  }
}
