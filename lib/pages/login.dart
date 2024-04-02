// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/api/local_auth_service.dart';
import 'package:sparks/pages/dashboard.dart';
import 'package:sparks/pages/signup.dart';
import 'package:sparks/widgets/widget.dart';
import '../widgets/pallete.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class LoginModel {
  final String plate;
  final String password;

  LoginModel({required this.plate, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'email': plate,
      'password': password,
    };
  }
}

class ApiResponse {
  final String token;

  ApiResponse({required this.token});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      token: json['token'],
    );
  }
}

class _LoginPageState extends State<LoginPage> {
  final _formfield = GlobalKey<FormState>();
  final plate = TextEditingController();
  final pass = TextEditingController();
  bool passToggle = true;
  bool authenticated = false;
  late LoginModel _loginModel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundSign(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 60),
              child: Form(
                key: _formfield,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 180),
                    Text(
                      'L O G I N',
                      style: logo,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Login to your account',
                      style:
                          TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                    ),
                    //space
                    SizedBox(
                      height: 30,
                    ),

                    //plate number
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: plate,
                      decoration: InputDecoration(
                        label: const Text('Plate number'),
                        hintText: "Enter your car's plate number",
                        prefixIcon: Icon(Icons.tag),
                      ),
                      //validate platenumber to database
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Plate Number";
                        }

                        return null;
                      },
                    ),
                    //space
                    SizedBox(
                      height: 5,
                    ),

                    //password
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: pass,
                      obscureText: passToggle,
                      decoration: InputDecoration(
                        label: const Text('Password'),
                        hintText: "Enter your password!",
                        prefixIcon: Icon(Icons.password),
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              passToggle = !passToggle;
                            });
                          },
                          child: Icon(passToggle
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                      ),

                      //validate password format
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Password";
                        }
                        if (pass.text.length < 6) {
                          return 'Password must be at least 8 characters long';
                        }
                        if (!value.contains(RegExp(r'[A-Z]'))) {
                          return 'Password must contain at least one uppercase letter';
                        }
                        if (!value.contains(RegExp(r'[a-z]'))) {
                          return 'Password must contain at least one lowercase letter';
                        }
                        if (!value.contains(RegExp(r'[0-9]'))) {
                          return 'Password must contain at least one number';
                        }
                        return null;
                      },
                    ),

                    //space
                    SizedBox(
                      height: 20,
                    ),

                    //LOGIN BUTTON
                    ElevatedButton(
                      onPressed: () {
                        if (_formfield.currentState!.validate()) {
                          _loginUser();
                        }
                      },
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(bottom: 10),
                          width: 150,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 7), //(x,y)
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 25),
                            ),
                          ),
                        ),
                      ),
                    ),

                    //space
                    Row(children: <Widget>[
                      Expanded(
                          child: Divider(
                        color: Colors.black54,
                      )),
                      Text("   OR   "),
                      Expanded(
                          child: Divider(
                        color: Colors.black54,
                      )),
                    ]),
                    SizedBox(
                      height: 10,
                    ),
                    //biometrics
                    SizedBox(
                      width: 150,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final authenticate = await LocalAuth.authenticate();

                          setState(() {
                            authenticated = authenticate;
                          });
                          if (authenticated) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Dashboard()));
                          }
                        },
                        icon: Icon(Icons.fingerprint),
                        label: Text('Biometrics'),
                      ),
                    ),
                    //space
                    SizedBox(
                      height: 30,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                              text: "Don't have an account?  ",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 0, 94, 131),
                                    fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    Navigator.of(context).push(PageTransition(
                                        child: SignPage(),
                                        type: PageTransitionType.fade));
                                  }),
                          ]),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _loginUser() async {
    final uri = Uri.parse('https://young-cloud-49021.pktriot.net/api/login');
    final body = jsonEncode(_loginModel.toJson());
    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await http.post(uri, body: body, headers: headers);

      if (response.statusCode == 201) {
        // Clear login form fields

        plate.clear();
        pass.clear();

        // Navigate to the Dashboard screen, replacing the current screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const Dashboard(),
          ),
        );

        // You can use the token here for further actions, e.g., storing it for future use
      } else {
        // Handle other status codes if needed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'An error occurred. Please check your connection and try again.'),
          ),
        );
      }
    } catch (error) {
      // Handle network errors or exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'An error occurred. Please check your connection and try again.'),
        ),
      );
    }
  }
}
