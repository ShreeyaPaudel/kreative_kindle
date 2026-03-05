class ApiEndpoints {
  ApiEndpoints._();

  // Physical device — WiFi IP (change if your network IP differs)
  static const String baseUrl = 'http://192.168.1.115:3001/api';

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout    = Duration(seconds: 30);

  // ── Auth ──────────────────────────────────────────────
  static const String register      = '/auth/register';
  static const String login         = '/auth/login';
  static const String updateProfile = '/auth'; // PUT /auth/:id

  // Password reset
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword  = '/auth/reset-password';

  // Google OAuth — web redirect (web frontend)
  static const String googleAuth       = '/auth/google';
  // Google OAuth — mobile idToken exchange (Flutter)
  static const String googleMobileAuth = '/auth/google/token';

  // ── Posts ─────────────────────────────────────────────
  static const String posts = '/posts'; // GET, POST
  // DELETE /posts/:id       → '$posts/$id'
  // POST   /posts/:id/like  → '$posts/$id/like'

  // ── Activities ────────────────────────────────────────
  static const String activities = '/activities'; // GET, GET/:id

  // ── Progress ──────────────────────────────────────────
  static const String progress           = '/progress';
  static const String progressComplete   = '/progress/complete';
  static const String progressFavourites = '/progress/favourites';

  // ── Children ──────────────────────────────────────────
  static const String children = '/children'; // GET, POST, PUT/:id, DELETE/:id

  // ── Upload ────────────────────────────────────────────
  static const String upload = '/upload';
}
