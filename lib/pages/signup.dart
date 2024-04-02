// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/pages/dashboard.dart';
import 'package:sparks/pages/login.dart';
import 'package:sparks/widgets/widget.dart';
import '../widgets/pallete.dart';
import 'package:http/http.dart' as http;

class SignPage extends StatefulWidget {
  @override
  State<SignPage> createState() => _SignPageState();
}

class RegisterModel {
  String? nickname;
  String? plate;
  String? email;
  String? password;

  RegisterModel({this.nickname, this.plate, this.email, this.password});

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      nickname: json['nickname'],
      plate: json['plate'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'plate': plate,
      'email': email,
      'password': password,
    };
  }
}

void main() async {}

class _SignPageState extends State<SignPage> {
  final _formfield = GlobalKey<FormState>();
  final nickname = TextEditingController();
  final plate = TextEditingController();
  final email = TextEditingController();
  final newpass = TextEditingController();
  final confirmpass = TextEditingController();
  bool passToggle = true;
  late RegisterModel _registerModel;

  @override
  void initState() {
    super.initState();
    _registerModel = RegisterModel();
  }

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
                    SizedBox(height: 175),
                    Text(
                      'SIGN UP',
                      style: logo,
                    ),

                    Text(
                      'Create your account',
                      style:
                          TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                    ),

                    //nickname
                    TextFormField(
                      keyboardType: TextInputType.name,
                      controller: nickname,
                      decoration: InputDecoration(
                        label: const Text('Nickname'),
                        hintText: "Enter your nickname",
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
                        keyboardType: TextInputType.name,
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
                        }),

                    //email
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: email,
                      decoration: InputDecoration(
                        label: const Text('Email Adress'),
                        hintText: "Enter your Email Address",
                        prefixIcon: Icon(Icons.email),
                      ),
                      //validate email proper format
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter your Email Adress";
                        }
                        bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.]+@[a-zA-Z0-9.! #$%'*+/=?^_`{|}~]+.[a-zA-Z]+")
                            .hasMatch(value);
                        if (!emailValid) {
                          return "Enter Valid Email";
                        }
                        return null;
                      },
                    ),

                    //new password
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: newpass,
                      obscureText: passToggle,
                      decoration: InputDecoration(
                        label: const Text('Password'),
                        hintText: "Enter your password!",
                        prefixIcon: Icon(Icons.password),
                      ),

                      //validate password format
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Password";
                        }
                        if (newpass.text.length < 6) {
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
                    //confirmpassword
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: confirmpass,
                      obscureText: passToggle,
                      decoration: InputDecoration(
                        label: const Text('Password'),
                        hintText: "Re-Enter your password!",
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

                    //SignUp BUTTON

                    ElevatedButton(
                      onPressed: () {
                        if (_formfield.currentState!.validate()) {
                          _formfield.currentState!.save();
                          _registerUser();

                          // call the _registerUser method
                        }
                      },
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: 150,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 58, 208, 50),
                              borderRadius: BorderRadius.circular(50)),
                          child: Center(
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                              text: "Have an Account? ",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                                text: 'Log In',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 0, 94, 131),
                                    fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    Navigator.of(context).push(PageTransition(
                                        child: LoginPage(),
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

  void _registerUser() async {
    final uri =
        Uri.parse('https://young-cloud-49021.pktriot.net/api/addClientUsers');
    final body = jsonEncode(_registerModel.toJson());
    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await http.post(uri, body: body, headers: headers);

      if (response.statusCode == 201) {
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
            builder: (context) => const Dashboard(),
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
