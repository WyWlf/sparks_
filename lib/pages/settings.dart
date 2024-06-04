// import 'dart:async';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:sparks/main.dart';
// import 'package:sparks/pages/feedbackform.dart';
import 'package:http/http.dart' as http;
import 'package:sparks/pages/dashboard.dart';
import 'package:sparks/widgets/pages.dart';

class Settings extends StatefulWidget {
  final String token;
  const Settings({super.key, required this.token});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String get token => widget.token;
  bool _passChange = false;
  TextEditingController nickname = TextEditingController();
  TextEditingController plate = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController newPass = TextEditingController();
  TextEditingController confPass = TextEditingController();
  TextEditingController currPass = TextEditingController();
  final _formfield = GlobalKey<FormState>();
  void getUserInfo() async {
    final uri = Uri.parse('http://192.168.254.104:5173/api/userInfo');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'token': token, 'onlyUsers': true});
    try {
      var client = http.Client();
      final response = await client.post(uri, body: body, headers: headers);
      if (response.statusCode == 200) {
        var json = response.body;
        var parseJson = jsonDecode(json);
        nickname.text = parseJson['row'][0]['user_id'];
        plate.text = parseJson['row'][0]['plate_number'];
        email.text = parseJson['row'][0]['email'];
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'An error occurred. Please check your connection and try again.'),
            ),
          );
        }
      }
    } catch (error) {
      // Handle network errors or exceptions
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'An error occurred. Please check your connection and try again.'),
          ),
        );
      }
    }
  }

  bool verifyForm() {
    return newPass.text.toLowerCase() == confPass.text.toLowerCase();
  }

  void updateAccount() async {
    if (verifyForm()) {
      final uri = Uri.parse('http://192.168.254.104:5173/api/updateUserInfo');
      final headers = {'Content-Type': 'application/json'};
      plate.text = plate.text.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
      plate.text = plate.text.toUpperCase();
      final body = jsonEncode({
        'token': token,
        'username': nickname.text,
        'plate': plate.text,
        'email': email.text,
        'pass': currPass.text,
        'newpass': newPass.text,
        'changepass': _passChange
      });
      try {
        var client = http.Client();
        final response = await client.post(uri, body: body, headers: headers);
        if (response.statusCode == 200) {
          var json = response.body;
          var parseJson = jsonDecode(json);
          if (parseJson['response']) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account updated successfully.'),
                ),
              );

              const storage = FlutterSecureStorage();
              await storage.write(key: 'token', value: parseJson['token']);

              Timer(const Duration(seconds: 1), () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Dashboard(token: parseJson['token']),
                ));
              });
            }
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(parseJson['msg']),
                ),
              );
            }
          }
        }
      } catch (error) {
        // Handle network errors or exceptions
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'An error occurred. Please check your connection and try again.'),
            ),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password does not match.'),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
    // Call your method to start fetching transactions and set up the timer
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const PagesBackground(),
        Scaffold(
          backgroundColor: const Color.fromARGB(0, 255, 255, 255),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(130),
            child: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 80,
              title: const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            children: [
              //Account Settings
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Colors.white,
                ),
                child: const ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text('Account Settings'),
                ),
              ),
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Form(
                    key: _formfield,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nickname,
                          decoration: const InputDecoration(
                            labelText: 'Nickname/Username',
                          ),
                          onChanged: (value) => {
                            nickname.text =
                                value.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This is a required field.";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: plate,
                          decoration: const InputDecoration(
                            labelText: 'Plate Number',
                          ),
                          // onChanged: (value) => {
                          //   plate.text =
                          //       value.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
                          // },
                        ),
                        TextFormField(
                          controller: email,
                          decoration: const InputDecoration(
                            labelText: 'Email (optional)',
                          ),
                        ),
                        if (_passChange)
                          Column(
                            children: [
                              Container(
                                decoration:
                                    const BoxDecoration(color: Colors.white),
                                child: TextFormField(
                                  obscureText: true,
                                  controller: currPass,
                                  decoration: const InputDecoration(
                                    labelText: 'Current Password',
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Enter Old Password";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Container(
                                decoration:
                                    const BoxDecoration(color: Colors.white),
                                child: TextFormField(
                                  obscureText: true,
                                  controller: newPass,
                                  decoration: const InputDecoration(
                                    labelText: 'New Password',
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Enter New Password";
                                    }

                                    if (newPass.text.length < 6) {
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
                              ),
                              Container(
                                decoration:
                                    const BoxDecoration(color: Colors.white),
                                child: TextFormField(
                                  obscureText: true,
                                  controller: confPass,
                                  decoration: const InputDecoration(
                                    labelText: 'Confirm Password',
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Enter Confirmation Password";
                                    }
                                    if (confPass.text.length < 6) {
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
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        const SizedBox(height: 30),
                        Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Save changes and hide the form
                                if (_formfield.currentState!.validate()) {
                                  setState(() {
                                    updateAccount();
                                  });
                                }
                              },
                              style: const ButtonStyle(
                                elevation: MaterialStatePropertyAll(3),
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.green),
                              ),
                              child: const Text(
                                'Save Changes',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 20, height: 20),
                            ElevatedButton(
                              onPressed: () {
                                // Save changes and hide the form
                                setState(() {
                                  currPass.clear();
                                  confPass.clear();
                                  newPass.clear();
                                  _passChange = !_passChange;
                                });
                              },
                              style: const ButtonStyle(
                                elevation: MaterialStatePropertyAll(3),
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.white),
                              ),
                              child: Text(
                                  !_passChange ? 'Change password' : 'Cancel',
                                  style: const TextStyle(color: Colors.black)),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                  // Container(
                  //   decoration: const BoxDecoration(
                  //     color: Colors.white,
                  //   ),
                  //   child: ListTile(
                  //     leading: const Icon(Icons.chat),
                  //     title: const Text('Feedback Form'),
                  //     trailing: IconButton(
                  //       icon: const Icon(Icons.arrow_forward_ios),
                  //       onPressed: () {
                  //         Navigator.of(context).pushReplacement(MaterialPageRoute(
                  //           builder: (context) => FeedbackForm(),
                  //         ));
                  //       },
                  //     ),
                  //   ),
                  // ),
                  )
            ],
          ),
        ),
      ],
    );
  }
}
