import 'package:flutter/foundation.dart';

/// Represents the possible states of the game
enum GameState {
  menu,
  playing,
  paused,
  gameOver,
}

/// Controls and manages the game state, providing a clean interface for state transitions
class GameStateController extends ChangeNotifier {
  GameState _currentState = GameState.menu;
  int _score = 0;
  int _highScore = 0;
  bool _isMuted = false;

  // Getters
  GameState get currentState => _currentState;
  int get score => _score;
  int get highScore => _highScore;
  bool get isMuted => _isMuted;

  // State transitions
  void startGame() {
    if (_currentState != GameState.playing) {
      _currentState = GameState.playing;
      _score = 0;
      notifyListeners();
    }
  }

  void pauseGame() {
    if (_currentState == GameState.playing) {
      _currentState = GameState.paused;
      notifyListeners();
    }
  }

  void resumeGame() {
    if (_currentState == GameState.paused) {
      _currentState = GameState.playing;
      notifyListeners();
    }
  }

  void gameOver() {
    if (_currentState == GameState.playing) {
      _currentState = GameState.gameOver;
      if (_score > _highScore) {
        _highScore = _score;
      }
      notifyListeners();
    }
  }

  void returnToMenu() {
    _currentState = GameState.menu;
    notifyListeners();
  }

  // Game actions
  void incrementScore() {
    _score++;
    notifyListeners();
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    notifyListeners();
  }

  // Reset state
  void reset() {
    _currentState = GameState.menu;
    _score = 0;
    notifyListeners();
  }
}
