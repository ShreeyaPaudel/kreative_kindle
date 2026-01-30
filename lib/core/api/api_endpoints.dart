class ApiEndpoints {
  ApiEndpoints._();

  // Android emulator localhost
  static const String baseUrl = 'http://10.0.2.2:3001/api';

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // SIMPLE endpoints (role is sent in body)
  static const String register = '/auth/register';
  static const String login = '/auth/login';
}
