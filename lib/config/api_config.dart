class ApiConfig {
  static const baseUrl = String.fromEnvironment('API_BASE_URL',
      defaultValue: 'http://localhost:8080/api');
}