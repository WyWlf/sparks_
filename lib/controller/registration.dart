import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sparks/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;

class RegistrationController extends GetxController {
  TextEditingController nickname = TextEditingController();
  TextEditingController plate = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController newpass = TextEditingController();
  TextEditingController confirmpass = TextEditingController();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> registerWithEmail() async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.registerEmail);
      Map body = {
        'nname': nickname.text,
        'platenum': plate.text,
        'email': email.text.trim(),
        'npass': newpass.text,
        'confirm': confirmpass.text
      };
    } catch (e) {}
  }
}
