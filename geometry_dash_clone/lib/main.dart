import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'game/core/game_engine.dart';
import 'game/state/game_state_controller.dart';
import 'screens/widgets/game_hud.dart';
import 'screens/widgets/game_menu.dart';
import 'screens/widgets/game_over_overlay.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Force portrait orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  // Enable immersive mode
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
    overlays: [],
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geometry Dash Clone',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ChangeNotifierProvider(
        create: (_) => GameStateController(),
        child: const GameScreen(),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final GameEngine _game;

  @override
  void initState() {
    super.initState();
    final stateController = context.read<GameStateController>();
    _game = GameEngine(stateController: stateController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Game layer
            GameWidget(
              game: _game,
              loadingBuilder: (context) => const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
              errorBuilder: (context, error) => Center(
                child: Text(
                  'Error: $error',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            
            // State-based UI layer
            Consumer<GameStateController>(
              builder: (context, gameState, child) {
                return Stack(
                  children: [
                    if (gameState.currentState == GameState.menu)
                      const GameMenu()
                    else if (gameState.currentState == GameState.playing)
                      const GameHUD()
                    else if (gameState.currentState == GameState.gameOver)
                      const GameOverOverlay(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _game.pauseEngine();
    super.dispose();
  }
}
