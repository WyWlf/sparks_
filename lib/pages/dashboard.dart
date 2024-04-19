import 'dart:async';
import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sparks/main.dart';
import 'package:sparks/pages/map.dart';
import 'package:sparks/pages/notifications.dart';
import 'package:sparks/pages/reportform.dart';
import 'package:sparks/pages/settings.dart';

import 'package:sparks/pages/transac_history.dart';
import 'package:sparks/widgets/pagesbg.dart';
import 'package:sparks/widgets/pages.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:sparks/widgets/pallete.dart';

class Dashboard extends StatefulWidget {
  final String token;
  const Dashboard({super.key, required this.token});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Timer _timer;
  String get token => widget.token;
  double totalHoursWorked = 5;
  double totalPayment = 0;
  bool initialized = false;
  bool counter = false;
  var parseJson = {};

  @override
  void initState() {
    super.initState();
    // Call your method to start fetching transactions and set up the timer
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');
    var formattedTime = 'Not active';
    double cost = 0;
    int hours = 0;
    int minutes = 0;
    final formattedDate = formatter.format(now);

    void getTransaction() async {
      final uri = Uri.parse(
          'https://young-cloud-49021.pktriot.net/api/getUserTransaction');
      final body = jsonEncode({'token': token});
      final headers = {'Content-Type': 'application/json'};
      try {
        final response = await http.post(uri, body: body, headers: headers);
        var json = jsonDecode(response.body);
        if (!initialized) {
          setState(() {
            parseJson = json;
            initialized = true;
          });
        } else if (initialized && json['resp'] == true) {
          _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
            setState(() {
              parseJson = json;
            });
          });
        }
      } catch (error) {
        print(error);
      }
    }

    getTransaction();
    if (initialized) {
      formattedTime = parseJson['hma'];
      cost = parseJson['cost'];
      hours = parseJson['time']['hours'];
      minutes = parseJson['time']['minutes'];
    }
    int available = 20;
    int used = 30;
    int total = available + used;

// Calculate percentages for pie chart slices
    final availablePercent = (available / total) * 100;
    final usedPercent = (used / total) * 100;

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
                'SPARKS',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),

              //notification button
              actions: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const NotificationsPage(),
                    ));
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Hero(
                      tag: 'notification',
                      child: Icon(
                        Icons.notifications,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          //menulist
          drawer: Drawer(
            backgroundColor: const Color.fromARGB(255, 194, 255, 191),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DrawerHeader(
                    child: Image.asset('images/sparkslogo.png'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'M E N U',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('D A S H B O A R D'),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => Dashboard(
                          token: widget.token,
                        ),
                      ));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: const Text('N O T I F I C A T I O N S'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const NotificationsPage(),
                      ));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.report),
                    title: const Text('R E P O R T  F O R M'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ReportPage(),
                      ));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.map),
                    title: const Text('P A R K I N G   M A P'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const MapPage(),
                      ));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('S E T T I N G S'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Settings(),
                      ));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('L O G O U T'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ));
                    },
                  ),
                ],
              ),
            ),
          ),

          //PARK TO PAY RECEIPT
          body: Column(children: [
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: 210,
                  width: 370,
                  color: Colors.white,
                ),
                Container(
                  margin: const EdgeInsets.all(5),
                  height: 200,
                  width: 360,
                  color: const Color.fromARGB(255, 51, 51, 51),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Time Started: ', style: white),
                      SizedBox(
                        width: 30,
                      ),
                      Text('Total Hours:', style: white),
                    ],
                  ),
                ),
                Container(),
                Positioned(
                  top: 115,
                  left: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(formattedTime, style: green),
                      const SizedBox(
                        width: 125,
                      ),
                      Text('$hours' ' hr. & ' '$minutes' ' min.', style: green),
                    ],
                  ),
                ),
                Positioned(
                  top: 140,
                  child: Column(
                    children: [
                      const Text('Total Amount: ', style: white),
                      Text('PHP ' '$cost', style: amount)
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.all(5),
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.5,
                  color: Colors.white,
                  child: const Text(
                    'PAY TO PARK',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),

                //TRANSACTION HISTORY

                Container(
                  padding: const EdgeInsets.only(right: 20, top: 10),
                  alignment: Alignment.topRight,
                  child: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: const Text("History"),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const TransactionHistory()));
                        },
                      ),
                    ],
                    child: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 130,
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        const TextSpan(text: 'Date: '),
                        TextSpan(text: formattedDate, style: green)
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            //title AVAILABLE PARKING SPACE
            Container(
              padding: const EdgeInsets.all(10),
              height: 50,
              width: MediaQuery.of(context).size.width,
              color: const Color.fromARGB(255, 51, 51, 51),
              child: const Text(
                'AVAILABLE PARKING SPACE',
                textAlign: TextAlign.center,
                style: AvPark,
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            //PIE CHART AVAILABLE PARKING SPACES

            Container(
              height: 110,
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(sections: [
                    PieChartSectionData(
                        value: availablePercent,
                        title: 'Available',
                        titleStyle: const TextStyle(color: Colors.white),
                        showTitle: true,
                        color: Colors.green),
                    PieChartSectionData(
                        value: usedPercent,
                        title: 'Used',
                        titleStyle: const TextStyle(color: Colors.white),
                        showTitle: true,
                        color: Colors.red),
                  ]),
                ),
              ),
            ),
            const SizedBox(height: 20),

            //summary of available parking space
            Positioned(
              top: 230,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                      'Total Available Parking Space: $available ($availablePercent%)',
                      style: sums),
                  Text('Used Parking Space : $used ($usedPercent%)',
                      style: sums),
                  const SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    minWidth: 150,
                    height: 50,
                    elevation: 10,
                    padding: const EdgeInsets.all(5),
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MapPage()));
                    },
                    child: const Text(
                      'View Parking Map',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  )
                ],
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
