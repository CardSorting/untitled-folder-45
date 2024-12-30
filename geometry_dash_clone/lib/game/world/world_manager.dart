import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../core/game_engine.dart';
import '../components/player_component.dart';
import '../components/obstacle_component.dart';
import '../components/background_component.dart';
import '../../config/game_config.dart';
import '../state/game_state_controller.dart';

/// Manages all game world entities and their interactions
class WorldManager extends Component with HasGameRef<GameEngine> {
  late final PlayerComponent player;
  late final BackgroundComponent background;
  final Random _random = Random();
  
  double _timeSinceLastSpawn = 0.0;
  double _currentSpeed;
  double _currentSpawnInterval;
  bool _isFirstObstacleSpawned = false;

  WorldManager({required GameEngine gameRef}) :
    _currentSpeed = GameConfig.obstacleSpeed,
    _currentSpawnInterval = GameConfig.obstacleSpawnInterval;

  @override
  Future<void> onLoad() async {
    // Add background
    background = BackgroundComponent();
    add(background);

    // Add ground
    add(
      RectangleComponent(
        position: Vector2(0, gameRef.size.y - GameConfig.groundHeight),
        size: Vector2(gameRef.size.x, GameConfig.groundHeight),
        paint: Paint()..color = Color(GameConfig.groundColor),
      ),
    );

    // Add player
    player = PlayerComponent();
    add(player);
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    if (gameRef.stateController.currentState != GameState.playing) return;

    _timeSinceLastSpawn += dt;
    if (_timeSinceLastSpawn >= _currentSpawnInterval) {
      _spawnObstacle();
      _timeSinceLastSpawn = 0.0;
    }

    // Collisions are now handled by Flame's collision detection system

    // Increase difficulty over time
    _updateDifficulty(dt);
  }

  void _spawnObstacle() {
    if (!_isFirstObstacleSpawned) {
      _isFirstObstacleSpawned = true;
      // Give player some time before first obstacle
      return;
    }

    final height = _random.nextDouble() * 
        (GameConfig.maxObstacleHeight - GameConfig.minObstacleHeight) + 
        GameConfig.minObstacleHeight;
        
    final obstacle = ObstacleComponent(
      position: Vector2(
        gameRef.size.x,
        gameRef.size.y - GameConfig.groundHeight - height,
      ),
      size: Vector2(30, height),
      speed: _currentSpeed,
    );

    add(obstacle);
  }

  void _updateDifficulty(double dt) {
    // Gradually increase speed and spawn rate
    _currentSpeed += dt * 1.0; // Increase speed by 1 unit per second
    _currentSpawnInterval = max(
      0.5, // Minimum spawn interval
      GameConfig.obstacleSpawnInterval * (GameConfig.obstacleSpeed / _currentSpeed)
    );
  }

  void updateScore(double dt) {
    // Update score based on survival time
    if (gameRef.stateController.currentState == GameState.playing) {
      _scoreTimer += dt;
      if (_scoreTimer >= 1.0) { // Increment score every second
        gameRef.stateController.incrementScore();
        _scoreTimer = 0.0;
      }
    }
  }

  double _scoreTimer = 0.0;

  void reset() {
    _currentSpeed = GameConfig.obstacleSpeed;
    _currentSpawnInterval = GameConfig.obstacleSpawnInterval;
    _timeSinceLastSpawn = 0.0;
    _isFirstObstacleSpawned = false;
    _scoreTimer = 0.0;

    // Remove all obstacles
    children.whereType<ObstacleComponent>().forEach((obstacle) {
      obstacle.removeFromParent();
    });

    // Reset player
    player.reset();
  }
}
