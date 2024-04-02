class ApiEndPoints {
  static const String baseUrl = 'https://young-cloud-49021.pktriot.net/api/';
  static _AuthEndPoints authEndPoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String registerEmail =
      'https://young-cloud-49021.pktriot.net/api/accounts';
  final String loginEmail = 'authaccount/login';
}
