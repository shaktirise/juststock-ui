class ApiConfig {
  // Allows override via: --dart-define=API_BASE_URL=...
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://backend-server-11f5.onrender.com',
  );
}


