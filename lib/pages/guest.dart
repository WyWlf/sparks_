import 'dart:async';
import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
import 'package:sparks/pages/signup.dart';
import 'package:sparks/widgets/pages.dart';

class GuestMode extends StatefulWidget {
  const GuestMode({super.key});

  @override
  State<GuestMode> createState() => _GuestModeState();
}

class _GuestModeState extends State<GuestMode> {
  late dynamic parkingJson = [];
  late Timer _newTimer;
  @override
  void initState() {
    super.initState();
    parkingSpaces();
    _newTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      parkingSpaces();
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _newTimer.cancel();
    super.dispose();
  }

  void parkingSpaces() async {
    final uri = Uri.parse('http://192.168.1.10:5173/api/getParkingFloors');
    try {
      final response = await http.get(uri);
      var json = jsonDecode(response.body);
      setState(() {
        parkingJson = json;
      });
    } catch (error) {
      // ignore: avoid_print
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    int available = 0;
    int used = 0;
    int total = 0;
    double availablePercent = 0;
    double usedPercent = 0;

    if (mounted) {
      if (parkingJson.isNotEmpty) {
        available = int.parse(parkingJson['spaces'][0]['max']) -
            int.parse(parkingJson['spaces'][0]['used']);
        used = int.parse(parkingJson['spaces'][0]['used']);
        total = available + used;
        if (total > 0) {
          availablePercent = (available / total) * 100;
          availablePercent = double.parse(availablePercent.toStringAsFixed(2));
        }
        if (used > 0) {
          usedPercent = (used / total) * 100;
          usedPercent = double.parse(usedPercent.toStringAsFixed(2));
        }
      }
    }
    return Stack(
      children: [
        const PagesBackground(),
        Scaffold(
          backgroundColor: const Color.fromARGB(0, 255, 255, 255),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(130),

            //SPARKS
            child: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 80,
              title: const Text(
                'Guest Mode',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          body: Center(
            child: Container(
                margin: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      height: 60,
                      width: 500,
                      color: const Color.fromARGB(255, 51, 51, 51),
                      child: const Text(
                        'AVAILABLE PARKING SPACES',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(20),
                          height: 350,
                          width: 500,
                          color: Colors.green.withOpacity(0.8),
                        ),
                        Container(
                          margin: const EdgeInsets.all(30),
                          height: 330,
                          width: 500,
                          color: Colors.white,
                        ),

                        // PIE CHART

                        Positioned(
                          top: 50,
                          child: SizedBox(
                            height: 150,
                            width: 250,
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: PieChart(
                                PieChartData(sections: [
                                  PieChartSectionData(
                                      value: availablePercent,
                                      title: 'Available',
                                      showTitle: true,
                                      titleStyle: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                      color: Colors.blue),
                                  PieChartSectionData(
                                      value: usedPercent,
                                      title: 'Used',
                                      showTitle: true,
                                      titleStyle: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                      color: Colors.red),
                                ]),
                              ),
                            ),
                          ),
                        ),

                        //text
                        Positioned(
                          top: 230,
                          child: Column(
                            children: [
                              Text(
                                'Available Slot: $available ($availablePercent%)',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Used Spaces: $used ($usedPercent%)',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Total Parking Spaces: $total ',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Positioned(
                          top: 340,
                          child: MaterialButton(
                            minWidth: 150,
                            height: 50,
                            elevation: 10,
                            padding: const EdgeInsets.all(5),
                            color: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            onPressed: () => showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text("You're on Guest Mode"),
                                content: const Text(
                                    'Please create an account to fully use the app '),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pushReplacement(
                                        context,
                                        PageTransition(
                                            child: const SignPage(),
                                            type: PageTransitionType.fade)),
                                    child: const Text('Create Account'),
                                  ),
                                ],
                              ),
                            ),
                            child: const Text(
                              'View Parking Map',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )),
          ),
        ),
      ],
    );
  }
}
