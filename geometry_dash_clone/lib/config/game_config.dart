class GameConfig {
  // Screen dimensions
  static const double designWidth = 411.0; // Standard mobile width
  static const double designHeight = 731.0; // Standard mobile height
  
  // Game physics
  static const double gravity = 900.0;
  static const double jumpForce = -500.0;
  static const double playerSize = 30.0;
  static const double groundHeight = 100.0;
  static const double obstacleSpeed = 200.0;
  
  // Spawn settings
  static const double obstacleSpawnInterval = 2.0;
  static const double minObstacleHeight = 40.0;
  static const double maxObstacleHeight = 100.0;
  
  // Colors
  static const int playerColor = 0xFF00FF00;
  static const int obstacleColor = 0xFFFF0000;
  static const int groundColor = 0xFF333333;
}
