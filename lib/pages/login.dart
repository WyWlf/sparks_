// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

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

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formfield = GlobalKey<FormState>();
  final plateController = TextEditingController();
  final passController = TextEditingController();
  bool passToggle = true;
  bool authenticated = false;

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
                      controller: plateController,
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
                      controller: passController,
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
                        if (passController.text.length < 6) {
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
                    InkWell(
                      onTap: () {
                        if (_formfield.currentState!.validate()) {
                          print("Success");
                          plateController.clear();
                          passController.clear();
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => Dashboard(),
                          ));
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
}
