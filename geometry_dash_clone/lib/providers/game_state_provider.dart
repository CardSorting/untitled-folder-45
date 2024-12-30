import 'package:flutter/foundation.dart';

enum GameState {
  menu,
  playing,
  paused,
  gameOver
}

class GameStateProvider extends ChangeNotifier {
  GameState _state = GameState.menu;
  int _score = 0;
  int _highScore = 0;
  bool _isMuted = false;

  GameState get state => _state;
  int get score => _score;
  int get highScore => _highScore;
  bool get isMuted => _isMuted;

  void startGame() {
    _state = GameState.playing;
    _score = 0;
    notifyListeners();
  }

  void pauseGame() {
    if (_state == GameState.playing) {
      _state = GameState.paused;
      notifyListeners();
    }
  }

  void resumeGame() {
    if (_state == GameState.paused) {
      _state = GameState.playing;
      notifyListeners();
    }
  }

  void gameOver() {
    _state = GameState.gameOver;
    if (_score > _highScore) {
      _highScore = _score;
    }
    notifyListeners();
  }

  void incrementScore() {
    _score++;
    notifyListeners();
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    notifyListeners();
  }

  void returnToMenu() {
    _state = GameState.menu;
    notifyListeners();
  }
}
