// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/api/local_auth_service.dart';
import 'package:sparks/pages/dashboard.dart';
import 'package:sparks/pages/signup.dart';
import 'package:sparks/widgets/decoration.dart';
import 'package:sparks/widgets/widget.dart';
import '../widgets/pallete.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class LoginModel {
  final String plate;
  final String password;
  final bool onlyUser;

  LoginModel(
      {required this.plate, required this.password, required this.onlyUser});

  Map<String, dynamic> toJson() {
    return {'username': plate, 'password': password, 'onlyUser': true};
  }
}

class _LoginPageState extends State<LoginPage> {
  final _formfield = GlobalKey<FormState>();
  final TextEditingController plate = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool passToggle = true;
  bool authenticated = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundSign(),
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 80,
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Form(
                key: _formfield,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      decoration: reg,
                      child: Column(
                        children: [
                          SizedBox(
                              height: 105,
                              child: Image.asset("images/sparkslogo.png")),
                          Text('Login', style: logo),
                          Text('Login to your account', style: def),

                          //plate number
                          TextFormField(
                            style: def,
                            keyboardType: TextInputType.emailAddress,
                            controller: plate,
                            decoration: InputDecoration(
                              hintText: "Enter username",
                              prefixIcon: Icon(Icons.tag),
                            ),
                            //validate platenumber to database
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter username";
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
                            style: def,
                            controller: password,
                            obscureText: passToggle,
                            decoration: InputDecoration(
                              hintText: "Enter password!",
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

                              if (password.text.length < 6) {
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
                              style: whiteButton,
                              onPressed: () {
                                if (_formfield.currentState!.validate()) {
                                  _loginUser();

                                  // call the _registerUser method
                                }
                              },
                              child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text('Login', style: buttons))),
                          SizedBox(height: 10),

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
                                final authenticate =
                                    await LocalAuth.authenticate();
                                setState(() {
                                  authenticated = authenticate;
                                });
                                if (authenticated) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Dashboard(
                                                token: '',
                                              )));
                                }
                              },
                              icon: Icon(Icons.fingerprint),
                              label: Text('Biometrics'),
                            ),
                          ),
                          //space
                          SizedBox(
                            height: 20,
                          ),
                          RichText(
                              text: TextSpan(children: <TextSpan>[
                            TextSpan(text: "Forgot Password? ", style: tspan)
                          ])),

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
                                      style: tspan,
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          Navigator.of(context).push(
                                              PageTransition(
                                                  child: SignPage(),
                                                  type:
                                                      PageTransitionType.fade));
                                        }),
                                ]),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
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
    final loginModel =
        LoginModel(plate: plate.text, password: password.text, onlyUser: true);
    final uri = Uri.parse('https://young-cloud-49021.pktriot.net/api/login');
    final body = jsonEncode(loginModel.toJson());
    final headers = {'Content-Type': 'application/json'};
    try {
      final response = await http.post(uri, body: body, headers: headers);
      var json = response.body;
      var parseJson = jsonDecode(json);

      dynamic code = parseJson['code'];
      dynamic status = parseJson['status'];
      if (status == 200 && code == 1) {
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => Center(
              child: LoadingAnimationWidget.halfTriangleDot(
                  color: Colors.green, size: 40),
            ),
          );
        }
        final String token = parseJson['token'];

        // Store the token securely (implement secure storage)
        // Store the token securely
        final storage = FlutterSecureStorage();
        await storage.write(key: 'token', value: token);
        // Navigate to Dashboard and potentially pass the token
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Dashboard(token: token),
          ),
        );
      } else if (status == 200 && code == 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid username or password.'),
          ),
        );
      } else if (status == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Account not found.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed. ${response.statusCode}'),
          ),
        );
      }
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'An error occurred. Please check your connection and try again.',
          ),
        ),
      );
    }
  }

  // ... rest of your class code (e.g., build method)
}
