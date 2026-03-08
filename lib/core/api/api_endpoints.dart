class ApiEndpoints {
  ApiEndpoints._();

  // Android emulator → 10.0.2.2 maps to host machine localhost
  // Physical device  → use your WiFi IP e.g. http://192.168.1.115:3001/api
  static const String baseUrl = 'http://10.0.2.2:3001/api'; //Emmulator

  // static const String baseUrl = 'http://192.168.1.115:3001/api'; //Physical device


  /// Base URL without /api — used for constructing media/upload URLs.
  /// Automatically follows baseUrl so switching emulator ↔ physical device
  /// only requires changing baseUrl above.
  static String get serverBase {
    final uri = Uri.parse(baseUrl);
    return '${uri.scheme}://${uri.host}:${uri.port}';
  }

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
