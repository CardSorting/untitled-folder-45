import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/obstacle_component.dart';
import '../config/game_config.dart';
import '../providers/game_state_provider.dart';
import 'components/player_component.dart';
import 'world/game_world.dart';

class GeometryDashGame extends FlameGame with TapDetector, HasCollisionDetection {
  late final PlayerComponent player;
  late final GameWorld gameWorld;
  late final GameStateProvider gameStateProvider;
  
  GeometryDashGame(this.gameStateProvider) : super(
    camera: CameraComponent.withFixedResolution(
      width: GameConfig.designWidth,
      height: GameConfig.designHeight,
    ),
  ) {
    images.prefix = '';
  }

  void incrementScore() {
    gameStateProvider.incrementScore();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Add player
    player = PlayerComponent();
    add(player);

    // Add game world
    gameWorld = GameWorld();
    add(gameWorld);
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (gameStateProvider.state == GameState.playing) {
      player.jump();
    }
    super.onTapDown(info);
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    if (gameStateProvider.state != GameState.playing) return;

    // Check for collisions with obstacles
    for (final component in children) {
      if (component is ObstacleComponent) {
        if (player.toRect().overlaps(component.toRect())) {
          handleCollision(component);
        }
      }
    }
  }

  void handleCollision(ObstacleComponent obstacle) {
    player.die();
    obstacle.onCollision();
    gameStateProvider.gameOver();
    pauseEngine();
  }

  void restart() {
    player.reset();
    gameWorld.reset();
    resumeEngine();
    gameStateProvider.startGame();
  }

  void pause() {
    pauseEngine();
    gameStateProvider.pauseGame();
  }

  void resume() {
    resumeEngine();
    gameStateProvider.resumeGame();
  }
}
