// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/pages/dashboard.dart';
import 'package:sparks/pages/login.dart';
import 'package:sparks/widgets/decoration.dart';
import 'package:sparks/widgets/widget.dart';
import '../widgets/pallete.dart';
import 'package:http/http.dart' as http;

class SignPage extends StatefulWidget {
  const SignPage({super.key});

  @override
  State<SignPage> createState() => _SignPageState();
}

class RegisterModel {
  final String nickname;
  final String plate;
  final String email;
  final String password;

  RegisterModel(
      {required this.nickname,
      required this.plate,
      required this.email,
      required this.password});
  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      nickname: json['nickname'],
      plate: json['plate'],
      email: json['email'],
      password: json['password'],
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'nickname': nickname,
  //     'plate': plate,
  //     'email': email,
  //     'password': password,
  //   };
  // }
}

void main() async {}

class _SignPageState extends State<SignPage> {
  final _formfield = GlobalKey<FormState>();
  // final nickname = TextEditingController();
  // final plate = TextEditingController();
  // final email = TextEditingController();
  // final newpass = TextEditingController();
  // final confirmpass = TextEditingController();
  TextEditingController nickname = TextEditingController();
  TextEditingController plate = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController newpass = TextEditingController();
  TextEditingController confirmpass = TextEditingController();

  bool passToggle = true;

  //method to
  Future<void> _registerUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Center(
        child: LoadingAnimationWidget.halfTriangleDot(
            color: Colors.green, size: 40),
      ),
    );
    var json = jsonEncode({
      'nickname': nickname.text,
      'plate': plate.text,
      'email': email.text,
      'password': newpass.text,
      'role': 1
    });
    final uri =
        Uri.parse('https://optimistic-grass-92004.pktriot.net/api/addClientUsers');
    final body = json;
    final headers = {'Content-Type': 'application/json'};

    try {
      var client = http.Client();
      final response = await client.post(uri, body: body, headers: headers);

      if (response.statusCode == 200) {
        // Registration successful
        // Clear registration form fields

        nickname.clear();
        plate.clear();
        email.clear();
        newpass.clear();
        confirmpass.clear();

        // Navigate to the Dashboard screen, replacing the current screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const Dashboard(
              token: '',
            ),
          ),
        );
      } else {
        // Handle network errors or exceptions
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred. ${response.statusCode}'),
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

  @override
  void initState() {
    super.initState();
  }

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
            child: Form(
              key: _formfield,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      decoration: reg,
                      child: Column(
                        children: [
                          //logo
                          SizedBox(
                              height: 105,
                              child: Image.asset("images/sparkslogo.png")),
                          Text('SIGN UP', style: logo),
                          Text('Create your account', style: def),

                          //signup form
                          TextFormField(
                            style: def,
                            keyboardType: TextInputType.name,
                            controller: nickname,
                            decoration: InputDecoration(
                              hintText: "Nickname",
                              prefixIcon: Icon(Icons.person),
                            ),

                            //validate platenumber to database
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your nickname";
                              }
                              //minimum of 3 characters
                              if (value.length < 3) {
                                return 'Nickname must be at least 3 characters long';
                              }
                              return null;
                            },
                          ),

                          //plate number
                          TextFormField(
                              style: def,
                              keyboardType: TextInputType.name,
                              controller: plate,
                              decoration: InputDecoration(
                                hintText: "Plate number",
                                prefixIcon: Icon(Icons.tag),
                              ),
                              //validate platenumber to database
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Enter Plate Number";
                                }
                                bool plateNumber =
                                    RegExp(r"^[a-z0-9]").hasMatch(value);
                                if (!plateNumber) {
                                  return "Please enter valid Plate Number(ABC123)";
                                }
                                return null;
                              }),

                          //email
                          TextFormField(
                            style: def,
                            keyboardType: TextInputType.emailAddress,
                            controller: email,
                            decoration: InputDecoration(
                              hintText: "Email Address (optional)",
                              prefixIcon: Icon(Icons.email),
                            ),
                            //validate email proper format
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return "Enter your Email Adress";
                            //   }
                            //   // bool emailValid =
                            //   //     RegExp(r"^[^a-z0-9]").hasMatch(value);
                            //   // if (!emailValid) {
                            //   //   return "Enter Valid Email";
                            //   // }
                            //   return null;
                            // },
                          ),

                          //new password
                          TextFormField(
                            style: def,
                            keyboardType: TextInputType.visiblePassword,
                            controller: newpass,
                            obscureText: passToggle,
                            decoration: InputDecoration(
                              hintText: "Password",
                              prefixIcon: Icon(Icons.password),
                            ),

                            //validate password format
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter Password";
                              }
                              if (newpass.text.length < 6) {
                                return 'Password must be at least 6 characters long';
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
                          //confirmpassword
                          TextFormField(
                            style: def,
                            keyboardType: TextInputType.visiblePassword,
                            controller: confirmpass,
                            obscureText: passToggle,
                            decoration: InputDecoration(
                              hintText: "Re-Enter password!",
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
                              if (value != newpass.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          //SIGNUP BUTTON
                          ElevatedButton(
                              style: greenButton,
                              onPressed: () {
                                if (_formfield.currentState!.validate()) {
                                  _formfield.currentState!.save();

                                  _registerUser();

                                  // call the _registerUser method
                                }
                              },
                              child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text('Sign Up', style: buttons))),
                          SizedBox(
                            height: 20,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: "Have an Account? ", style: def),
                                  TextSpan(
                                      text: 'Log In',
                                      style: tspan,
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          Navigator.of(context).push(
                                              PageTransition(
                                                  child: LoginPage(),
                                                  type:
                                                      PageTransitionType.fade));
                                        }),
                                ]),
                              ),
                            ],
                          )
                          //SignUp BUTTON
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
}
