import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../config/game_config.dart';
import '../core/game_engine.dart';
import '../state/game_state_controller.dart';

/// Background component that creates a scrolling grid effect
class BackgroundComponent extends Component with HasGameRef<GameEngine> {
  static const double _gridSpacing = 40.0;
  static const double _scrollSpeed = 100.0;
  double _scrollOffset = 0.0;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _drawBackground(canvas);
    _drawGrid(canvas);
    _drawVignette(canvas);
  }

  void _drawBackground(Canvas canvas) {
    final paint = Paint()
      ..color = const Color(0xFF1a1a1a)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, gameRef.size.x, gameRef.size.y),
      paint,
    );
  }

  void _drawGrid(Canvas canvas) {
    final paint = Paint()
      ..color = const Color(0xFF2a2a2a)
      ..strokeWidth = 1.0;

    // Draw vertical lines with scroll effect
    for (var i = -_scrollOffset; i < gameRef.size.x + _gridSpacing; i += _gridSpacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, gameRef.size.y),
        paint,
      );
    }

    // Draw horizontal lines
    for (var i = 0.0; i < gameRef.size.y + _gridSpacing; i += _gridSpacing) {
      canvas.drawLine(
        Offset(0, i),
        Offset(gameRef.size.x, i),
        paint,
      );
    }
  }

  void _drawVignette(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, gameRef.size.x, gameRef.size.y);
    final gradient = RadialGradient(
      center: Alignment.center,
      radius: 1.2,
      colors: [
        Colors.transparent,
        Colors.black.withOpacity(0.3),
      ],
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..blendMode = BlendMode.darken;

    canvas.drawRect(rect, paint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Only scroll when game is playing
    if (gameRef.stateController.currentState == GameState.playing) { // Now GameState is properly imported
      _scrollOffset = (_scrollOffset + _scrollSpeed * dt) % _gridSpacing;
    }
  }
}
