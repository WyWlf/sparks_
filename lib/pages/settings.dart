import 'package:flutter/material.dart';
import 'package:sparks/main.dart';

import 'package:sparks/widgets/pages.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _showForm = false;
  bool _passChange = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PagesBackground(),
        Scaffold(
          backgroundColor: Color.fromARGB(0, 255, 255, 255),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(130),
            child: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                'Settings',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          body: ListView(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Colors.white,
                ),
                child: ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text('Account Settings'),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        _showForm = !_showForm;
                      });
                    },
                  ),
                ),
              ),
              if (_showForm)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Nickname',
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Plate Number',
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                        ),
                      ),
                      Container(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Current Password',
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  _passChange = !_passChange;
                                });
                              },
                              child: Icon(Icons.edit),
                            ),
                          ),
                          obscureText: true,
                        ),
                      ),
                      if (_passChange)
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(color: Colors.white),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'New Password',
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                // Save changes and hide the form
                                setState(() {
                                  _passChange = false;
                                });
                              },
                              style: ButtonStyle(
                                elevation: MaterialStatePropertyAll(8),
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.white),
                              ),
                              child: Text('Save New Password',
                                  style: TextStyle(color: Colors.black)),
                            ),
                          ],
                        ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Save changes and hide the form
                          setState(() {
                            _showForm = false;
                          });
                        },
                        style: ButtonStyle(
                          elevation: MaterialStatePropertyAll(8),
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.green),
                        ),
                        child: Text(
                          'Save Changes',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Log Out'),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
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
