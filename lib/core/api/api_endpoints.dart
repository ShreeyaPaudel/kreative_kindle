class ApiEndpoints {
  ApiEndpoints._();

  // Physical device — WiFi IP
  static const String baseUrl = 'http://192.168.1.69:3001/api';

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // SIMPLE endpoints (role is sent in body)
  static const String register = '/auth/register';
  static const String login    = '/auth/login';

  // Password reset
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword  = '/auth/reset-password';

  // Google OAuth
  static const String googleAuth = '/auth/google';
}
