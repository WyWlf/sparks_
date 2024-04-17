import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sparks/widgets/pagesbg.dart';
import 'package:http/http.dart' as http;

class FeedbackForm extends StatefulWidget {
  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  int _rating = 2; // Initial rating value (out of 5)
  String _feedback = ""; // To store user feedback text

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //background
        PagesBackground(),
        Scaffold(
          backgroundColor: Color.fromARGB(0, 255, 255, 255),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(130),
            child: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 80,
              title: Text(
                'Feedback Form ',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      //FORM STARTS HERE
                      child: Column(
                        children: [
                          const Text(
                            'RATE US!!',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          //RATING
                          const Text(
                            'How do you rate this app?',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          //STARS
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                                5, (index) => _buildRatingStar(index)),
                          ),
                        ],
                      )),

                  const SizedBox(height: 20.0),

                  // Feedback text field
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Leave your feedback here...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: Colors.grey, // Optional border color
                        ),
                      ),
                    ),
                    maxLines: 6,
                    //saving data
                    onChanged: (value) => setState(() => _feedback = value),
                  ),
                  const SizedBox(height: 20.0),

                  // Submit button
                  MaterialButton(
                    height: 40,
                    color: Color.fromARGB(255, 18, 229, 28),
                    splashColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    elevation: 10,
                    onPressed: () async {
                      // create json var to use it for calling
                      var feedbackData = {
                        'rating': _rating,
                        'feedback': _feedback,
                      };
                      //test
                      print('Feedback data: $feedbackData');

                      // Send a POST request to the API with the feedback data
                      var response = await http.post(
                        Uri.parse(
                            'https://young-cloud-49021.pktriot.net/api/addReportForm'),
                        headers: {
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                        body: jsonEncode(feedbackData),
                      );

                      // Check if the request was successful
                      if (response.statusCode == 200) {
                        // Show a success message or navigate back
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Feedback submitted successfully')),
                        );
                      } else {
                        // Show an error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error submitting feedback')),
                        );
                      }
                    },
                    child: const Text('Submit'),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  // Function to build a single rating star icon
  Widget _buildRatingStar(int index) {
    return IconButton(
      icon: Icon(
        index < _rating ? Icons.star : Icons.star_border,
        color: Colors.amber,
      ),
      onPressed: () => setState(() => _rating = index + 1),
    );
  }
}
