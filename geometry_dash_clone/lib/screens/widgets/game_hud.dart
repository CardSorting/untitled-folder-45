import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../game/state/game_state_controller.dart';

class GameHUD extends StatelessWidget {
  const GameHUD({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Top bar with score and controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Score display
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      ListenableBuilder(
                        listenable: context.read<GameStateController>(),
                        builder: (context, _) {
                          return Text(
                            '${context.read<GameStateController>().score}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                
                // Control buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Mute button
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          context.select<GameStateController, bool>(
                            (controller) => controller.isMuted,
                          )
                              ? Icons.volume_off
                              : Icons.volume_up,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          context.read<GameStateController>().toggleMute();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Pause button
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.pause,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          context.read<GameStateController>().pauseGame();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
