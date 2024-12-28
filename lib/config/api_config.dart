class ApiConfig {
  static const baseUrl = String.fromEnvironment('API_BASE_URL',
      defaultValue: 'http://192.168.57.6:8080/api');
}