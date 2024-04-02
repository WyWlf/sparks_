import 'package:flutter/material.dart';
import 'package:sparks/widgets/pagesbg.dart';

class FeedbackForm extends StatefulWidget {
  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  int _rating = 3; // Initial rating value (out of 5)
  String _feedback = ""; // To store user feedback text

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
                      child: Column(
                        children: [
                          const Text(
                            'RATE US!!',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'How much do you love this app?',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                                5, (index) => _buildRatingStar(index)),
                          ),
                        ],
                      )),
                  // Rating section

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
                    maxLines: 5,
                    onChanged: (value) => setState(() => _feedback = value),
                  ),
                  const SizedBox(height: 20.0),

                  // Submit button
                  ElevatedButton(
                    onPressed: () {
                      // Handle feedback submission logic here
                      // You can send the feedback data (rating and text) to your backend
                      print('Rating: $_rating, Feedback: $_feedback');
                      // After submission, you can show a success message or navigate back
                    },
                    child: const Text('Submit Feedback'),
                  ),
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
