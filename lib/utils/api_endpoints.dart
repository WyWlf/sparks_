class ApiEndPoints {
  static const String baseUrl = 'http://192.168.254.104:5173/api/';
  static _AuthEndPoints authEndPoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String registerEmail =
      'http://192.168.254.104:5173/api/accounts';
  final String loginEmail = 'authaccount/login';
}
