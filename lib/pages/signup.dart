// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/pages/dashboard.dart';
import 'package:sparks/pages/login.dart';
import 'package:sparks/widgets/widget.dart';
import '../widgets/pallete.dart';

class SignPage extends StatefulWidget {
  @override
  State<SignPage> createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  final _formfield = GlobalKey<FormState>();
  final nicknameController = TextEditingController();
  final plateController = TextEditingController();
  final emailController = TextEditingController();
  final newpassController = TextEditingController();
  final confirmpasscontroller = TextEditingController();
  bool passToggle = true;

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
                      controller: nicknameController,
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
                        }),

                    //email
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
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
                      controller: newpassController,
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
                        if (newpassController.text.length < 8) {
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
                      controller: confirmpasscontroller,
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
                        if (value != newpassController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    //SignUp BUTTON

                    InkWell(
                      onTap: () {
                        if (_formfield.currentState!.validate()) {
                          print("Success");
                          nicknameController.clear();
                          plateController.clear();
                          emailController.clear();
                          newpassController.clear();
                          confirmpasscontroller.clear();
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => const Dashboard(),
                          ));
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
}
