import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/main.dart';
import 'package:sparks/pages/login.dart';
import 'package:sparks/widgets/pages.dart';

class GuestMode extends StatefulWidget {
  const GuestMode({super.key});

  @override
  State<GuestMode> createState() => _GuestModeState();
}

final available = 20;
final used = 30;
final total = available + used;

// Calculate percentages for pie chart slices
final availablePercent = (available / total) * 100;
final usedPercent = (used / total) * 100;

class _GuestModeState extends State<GuestMode> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PagesBackground(),
        Scaffold(
          backgroundColor: Color.fromARGB(0, 255, 255, 255),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(130),

            //SPARKS
            child: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
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
                margin: EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      height: 60,
                      width: 500,
                      color: Color.fromARGB(255, 51, 51, 51),
                      child: Text(
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
                          margin: EdgeInsets.all(20),
                          height: 350,
                          width: 500,
                          color: Colors.green.withOpacity(0.8),
                        ),
                        Container(
                          margin: EdgeInsets.all(30),
                          height: 330,
                          width: 500,
                          color: Colors.white,
                        ),

                        // PIE CHART

                        Positioned(
                          top: 50,
                          child: Container(
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
                                      color: Colors.blue),
                                  PieChartSectionData(
                                      value: usedPercent,
                                      title: 'Used',
                                      showTitle: true,
                                      color: Colors.orange),
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
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Used Spaces: $used ($usedPercent%)',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Total Parking Spaces: $total ',
                                style: TextStyle(
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
                            padding: EdgeInsets.all(5),
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
                                            child: HomePage(),
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
