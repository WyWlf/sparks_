import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sparks/widgets/pagesbg.dart';
import 'package:http/http.dart' as http;
import 'package:sparks/widgets/pallete.dart';

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({super.key});

  @override
  FeedbackFormState createState() => FeedbackFormState();
}

class FeedbackFormState extends State<FeedbackForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  void passwordReset() async {
    if (email.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email address is empty.'),
          ),
        );
      }
    } else {
      final uri = Uri.parse('http://192.168.1.10:5173/api/emailSender');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'email': email.text,
      });
      try {
        var client = http.Client();
        final response = await client.post(uri, body: body, headers: headers);
        if (response.statusCode == 200) {
          var json = response.body;
          var parseJson = jsonDecode(json);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${parseJson['msg']}'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //background
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
                  'Password reset',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            body: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24))),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Enter the email address that is connected to your account.',
                                softWrap: true,
                                style: TextStyle(),
                              ),
                              TextFormField(
                                style: def,
                                controller: email,
                                decoration: const InputDecoration(
                                  icon: Icon(
                                    Icons.email_outlined,
                                    size: 24,
                                  ),
                                  labelText: 'Enter your email address',
                                ),
                                validator: validateEmail,
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              const Text(
                                "If your account has no linked email address. You will need to submit a ticket to the support team here at sparks@gmail.com and submit necessary information for your account's retrieval. ",
                                softWrap: true,
                                style: TextStyle(),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () {
                                   if (_formKey.currentState!.validate()) {
                                    passwordReset();
                                   }
                                },
                                style: const ButtonStyle(
                                  elevation: MaterialStatePropertyAll(3),
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.green),
                                ),
                                child: const Text(
                                  'Reset password',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                )))
      ],
    );
  }
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter an email address';
  }

  // Regular expression for email validation
  String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  RegExp regex = RegExp(pattern);

  if (!regex.hasMatch(value)) {
    return 'Enter a valid email address';
  }
  return null;
}
