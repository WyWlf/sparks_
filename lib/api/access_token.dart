import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AccessToken {
  static const storage = FlutterSecureStorage();

  static Future<dynamic> getAccessToken() async {
    return await storage.read(key: 'token');
  }
}
