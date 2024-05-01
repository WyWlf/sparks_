class ApiEndPoints {
  static const String baseUrl = 'https://optimistic-grass-92004.pktriot.net/api/';
  static _AuthEndPoints authEndPoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String registerEmail =
      'https://optimistic-grass-92004.pktriot.net/api/accounts';
  final String loginEmail = 'authaccount/login';
}
