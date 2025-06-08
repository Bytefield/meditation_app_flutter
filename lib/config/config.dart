class AppConfig {
  // Use your local IP address instead of localhost for Android emulator
  static const String apiUrl = 'http://10.0.2.2:5000'; // For Android emulator
  // static const String apiUrl = 'http://localhost:5000'; // For iOS simulator or physical device
  
  // Add other configuration constants here
  static const String appName = 'MeditApp';
  static const String appVersion = '1.0.0';
  
  // Timeouts
  static const int connectTimeout = 5000; // 5 seconds
  static const int receiveTimeout = 5000; // 5 seconds
  
  // Pagination
  static const int defaultPageSize = 10;
}
