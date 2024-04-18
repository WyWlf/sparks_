import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sparks/main.dart';
import 'package:sparks/pages/feedbackform.dart';
import 'package:http/http.dart' as http;
import 'package:sparks/widgets/pages.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _showForm = false;
  bool _passChange = false;
  TextEditingController nickname = TextEditingController();
  TextEditingController plate = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController newPass = TextEditingController();
  TextEditingController confPass = TextEditingController();
  TextEditingController currPass = TextEditingController();
  Future<void> getUserInfo() async {
    final uri = Uri.parse('https://young-cloud-49021.pktriot.net/api/getUsers');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'search': 'haroldtest', 'onlyUsers': true});
    try {
      var client = http.Client();
      final response = await client.post(uri, body: body, headers: headers);
      if (response.statusCode == 200) {
        var json = response.body;
        var parseJson = jsonDecode(json);
        nickname.text = parseJson['row'][0]['user_id'];
        plate.text = parseJson['row'][0]['plate_number'];
        email.text = parseJson['row'][0]['email'];
      }
    } catch (error) {
      // Handle network errors or exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'An error occurred. Please check your connection and try again.'),
        ),
      );
    }
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
                child: ListTile(
                  leading: const Icon(Icons.account_circle),
                  title: const Text('Account Settings'),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        _showForm = !_showForm;
                        getUserInfo();
                      });
                    },
                  ),
                ),
              ),
              if (_showForm)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nickname,
                        decoration: const InputDecoration(
                          labelText: 'Nickname/Username',
                        ),
                      ),
                      TextFormField(
                        controller: plate,
                        decoration: const InputDecoration(
                          labelText: 'Plate Number',
                        ),
                      ),
                      TextFormField(
                        controller: email,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: currPass,
                        decoration: InputDecoration(
                          labelText: 'Current Password',
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                _passChange = !_passChange;
                              });
                            },
                            child: const Icon(Icons.edit),
                          ),
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
                                controller: newPass,
                                decoration: const InputDecoration(
                                  labelText: 'New Password',
                                ),
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
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                // Save changes and hide the form
                                setState(() {
                                  _passChange = false;
                                });
                              },
                              style: const ButtonStyle(
                                elevation: MaterialStatePropertyAll(8),
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.white),
                              ),
                              child: const Text('Save New Password',
                                  style: TextStyle(color: Colors.black)),
                            ),
                          ],
                        ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Save changes and hide the form
                          setState(() {
                            _showForm = false;
                          });
                        },
                        style: const ButtonStyle(
                          elevation: MaterialStatePropertyAll(8),
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.green),
                        ),
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: ListTile(
                  leading: const Icon(Icons.chat),
                  title: const Text('Feedback Form'),
                  trailing: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => FeedbackForm(),
                      ));
                    },
                  ),
                ),
              ),

              //log out
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text('Log Out'),
                  trailing: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const MyApp(),
                      ));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
