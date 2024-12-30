import 'package:flame/game.dart';
import 'package:flame/components.dart';
import '../world/world_manager.dart';
import '../input/input_controller.dart';
import '../state/game_state_controller.dart';

/// Core game engine that manages the main game loop and coordinates between systems
class GameEngine extends FlameGame with HasCollisionDetection {
  final GameStateController stateController;
  late final WorldManager worldManager;
  late final InputController inputController;

  GameEngine({required this.stateController}) : super(
    camera: CameraComponent.withFixedResolution(
      width: 411.0,  // Standard mobile width
      height: 731.0, // Standard mobile height
    ),
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Initialize core systems
    worldManager = WorldManager(gameRef: this);
    inputController = InputController(gameRef: this);

    // Add core systems
    add(worldManager);
    add(inputController);

    // Set up initial game state
    stateController.addListener(_onGameStateChanged);
  }

  void _onGameStateChanged() {
    switch (stateController.currentState) {
      case GameState.playing:
        resumeEngine();
        break;
      case GameState.paused:
      case GameState.gameOver:
        pauseEngine();
        break;
      case GameState.menu:
        resetGame();
        break;
    }
  }

  void resetGame() {
    worldManager.reset();
    resumeEngine();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (stateController.currentState != GameState.playing) return;
    
    // Core game loop updates here
    worldManager.updateScore(dt);
  }
}
