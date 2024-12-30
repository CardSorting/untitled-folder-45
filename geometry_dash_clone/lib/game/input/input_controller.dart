import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import '../core/game_engine.dart';
import '../state/game_state_controller.dart';

/// Handles all input events for the game, providing a clean interface for input handling
class InputController extends Component with TapCallbacks, HasGameRef<GameEngine> {
  InputController({required FlameGame gameRef});

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    
    final currentState = gameRef.stateController.currentState;
    if (currentState == GameState.playing) {
      gameRef.worldManager.player.jump();
    } else if (currentState == GameState.paused) {
      gameRef.stateController.resumeGame();
    }
    // Other states are handled in UI layer
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    // Could be used for more complex input mechanics
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    super.onTapCancel(event);
    // Could be used for more complex input mechanics
  }

  // Could add gesture handlers for more complex mechanics
  // void onPanUpdate(DragUpdateInfo info) {
  //   // Handle pan/drag gestures
  // }
}
