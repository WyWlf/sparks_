import 'dart:async';
import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sparks/api/access_token.dart';
import 'package:sparks/main.dart';
import 'package:sparks/pages/map.dart';
import 'package:sparks/pages/reportform.dart';
import 'package:sparks/pages/settings.dart';
import 'package:sparks/pages/transac_history.dart';
import 'package:sparks/widgets/pagesbg.dart';
import 'package:sparks/widgets/pages.dart';
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
  late Timer _newTimer;
  late Timer _notifTimer;
  String openingTime = '';
  String closingTime = '';
  String get token => widget.token;
  bool initialized = false;
  bool counter = false;
  var parseJson = {};
  var parkingJson = {};
  var config = {};

  void getTransaction() async {
    final uri = Uri.parse('http://192.168.1.10:5173/api/getUserTransaction');
    final body = jsonEncode({'token': token});
    final headers = {'Content-Type': 'application/json'};
    try {
      final response = await http.post(uri, body: body, headers: headers);
      var json = jsonDecode(response.body);
      setState(() {
        if (json['resp'] == true) {
          parseJson = json;
          initialized = true;
        } else {
          parseJson = {};
          initialized = true;
        }
      });
    } catch (error) {
      print(error);
    }
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
      print(error);
    }
  }

  String convertTo12HourFormat(String time) {
    final DateFormat formatter = DateFormat('hh:mm a');
    final DateTime dateTime = DateFormat('HH:mm').parse(time);
    return formatter.format(dateTime);
  }

  void getConfig() async {
    final uri = Uri.parse('http://192.168.1.10:5173/api/getConfiguration');
    try {
      final response = await http.get(uri);
      var json = jsonDecode(response.body);
      setState(() {
        config = jsonDecode(json['row'][0]['settings']);
        openingTime = config['openingTime'];
        closingTime = config['closingTime'];
      });
      print(config);
    } catch (error) {
      print(error);
    }
  }

  void getNotifications() async {
    final uri =
        Uri.parse('http://192.168.1.10:5173/api/getUserNotificationReports');
    final body = jsonEncode({'token': token});
    final headers = {'Content-Type': 'application/json'};
    try {
      final response = await http.post(uri, body: body, headers: headers);
      var json = jsonDecode(response.body);
      setState(() {
        if (json['resp']) {
          AwesomeNotifications().createNotification(
            content: NotificationContent(
                criticalAlert: true,
                id: 1,
                channelKey: "basic_channel",
                title: "A report has been received.",
                body:
                    "Someone has submitted a report concerning your vehicle."),
          );
        }
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    getConfig();
    getTransaction();
    parkingSpaces();
    getNotifications();

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      getTransaction();
    });
    _newTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      parkingSpaces();
    });

    _notifTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      getNotifications();
    });
    super.initState();
    // Call your method to start fetching transactions and set up the timer
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    _newTimer.cancel();
    _notifTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var formattedTime = 'Not active';
    double cost = 0.0;
    int hours = 0;
    int minutes = 0;

    int available = 0;
    int used = 0;
    int total = 0;
    double availablePercent = 0;
    double usedPercent = 0;

    if (initialized) {
      if (parseJson.isNotEmpty) {
        formattedTime = parseJson['hma'];
        double parsedCost = double.parse(parseJson['cost'].toString());
        cost = parsedCost;
        hours = parseJson['time']['hours'];
        minutes = parseJson['time']['minutes'];
      } else {
        formattedTime = 'Not active';
        cost = 0;
        hours = 0;
        minutes = 0;
      }
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

    return MaterialApp(
      title: 'SPARKS',
      home: Stack(
        children: [
          const PagesBackground(),
          Scaffold(
            backgroundColor: const Color.fromARGB(0, 255, 255, 255),
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(150),

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
                      fontWeight: FontWeight.bold),
                ),

                //notification button
                // actions: <Widget>[
                //   GestureDetector(
                //     onTap: () {
                //       Navigator.of(context).push(MaterialPageRoute(
                //         builder: (context) => const NotificationsPage(),
                //       ));
                //     },
                //     child: const Padding(
                //       padding: EdgeInsets.only(right: 20),
                //       child: Hero(
                //         tag: 'notification',
                //         child: Icon(
                //           Icons.notifications,
                //           color: Colors.white,
                //         ),
                //       ),
                //     ),
                //   ),
                // ],
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
                      'MENU',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      leading: const Icon(Icons.home),
                      title: const Text('DASHBOARD'),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Dashboard(
                            token: widget.token,
                          ),
                        ));
                      },
                    ),
                    // ListTile(
                    //   leading: const Icon(Icons.notifications),
                    //   title: const Text('NOTIFICATIONS'),
                    //   onTap: () {
                    //     Navigator.of(context).push(MaterialPageRoute(
                    //       builder: (context) => const NotificationsPage(),
                    //     ));
                    //   },
                    // ),
                    ListTile(
                      leading: const Icon(Icons.car_crash_outlined),
                      title: const Text('PARKING HISTORY'),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TransactionHistory(
                            token: widget.token,
                          ),
                        ));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.report),
                      title: const Text('REPORTS'),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ReportPage(),
                        ));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.map),
                      title: const Text('PARKING MAP'),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const MapPage(),
                        ));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('ACCOUNT SETTINGS'),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Settings(
                            token: widget.token,
                          ),
                        ));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('LOGOUT'),
                      onTap: () async {
                        await AccessToken.storage.delete(key: 'token');
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
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    height: 240,
                    width: 370,
                    color: Colors.white,
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border: Border.all(width: 0, color: Colors.white),
                          color: const Color.fromARGB(255, 51, 51, 51)),
                      child: Flex(
                        direction: Axis.vertical,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 0, color: Colors.white),
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: const Text(
                              'PAY-TO-PARK',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                          // receipt
                          const SizedBox(
                            height: 10,
                          ),
                          Flex(
                            direction: Axis.vertical,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(31, 0, 0, 0),
                                    child: Column(
                                      children: [
                                        const Text(
                                          'Opening Time:',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          openingTime.isEmpty
                                              ? 'Loading...'
                                              : convertTo12HourFormat(
                                                  openingTime),
                                          style: const TextStyle(
                                              color: Colors.blue, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 31, 0),
                                    child: Column(
                                      children: [
                                        const Text(
                                          'Closing Time:',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          openingTime.isEmpty
                                              ? 'Loading...'
                                              : convertTo12HourFormat(
                                                  closingTime),
                                          style: const TextStyle(
                                              color: Colors.red, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Flex(
                                direction: Axis.horizontal,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flex(
                                    direction: Axis.vertical,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 15, 0, 0),
                                        child: const Text(
                                          'Time Parked:',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 0, 0, 0),
                                        child: Text(
                                          formattedTime,
                                          style: const TextStyle(
                                              color: Colors.green,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Flex(
                                    direction: Axis.vertical,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 15, 20, 0),
                                        child: const Text(
                                          'Park Time:',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 20, 0),
                                        child: Text(
                                          '$hours' ' hr. & ' '$minutes' ' min.',
                                          style: const TextStyle(
                                              color: Colors.green,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Flex(
                                direction: Axis.vertical,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 40, 0, 0)),
                                  const Text(
                                    'PARKING FEE',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Text(
                                    'PHP ' '$cost',
                                    style: const TextStyle(
                                        color: Colors.green, fontSize: 20),
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 70),

              //title AVAILABLE PARKING SPACE
              Container(
                padding: const EdgeInsets.all(10),
                height: 50,
                width: MediaQuery.of(context).size.width,
                color: const Color.fromARGB(255, 51, 51, 51),
                child: const Text(
                  'PARKING SPACE INFORMATION',
                  textAlign: TextAlign.center,
                  style: AvPark,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              //PIE CHART AVAILABLE PARKING SPACES

              SizedBox(
                height: 110,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(sections: [
                      PieChartSectionData(
                          value: availablePercent,
                          title: 'Available',
                          titleStyle: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          showTitle: true,
                          color: Colors.green.shade500),
                      PieChartSectionData(
                          value: usedPercent,
                          title: 'Used',
                          titleStyle: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          showTitle: true,
                          color: Colors.red.shade500),
                    ]),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              //summary of available parking space
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flex(
                    direction: Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          'Total Available Parking Space: $available ($availablePercent%)',
                          style: sums),
                      Text('Occupied Parking Space : $used ($usedPercent%)',
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
                ],
              )
            ]),
          ),
        ],
      ),
    );
  }
}
