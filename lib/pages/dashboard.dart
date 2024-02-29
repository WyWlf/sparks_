// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:sparks/main.dart';
import 'package:sparks/pages/map.dart';
import 'package:sparks/pages/notifications.dart';
import 'package:sparks/pages/reportform.dart';
import 'package:sparks/pages/settings.dart';
import 'package:sparks/widgets/pagesbg.dart';
import 'package:sparks/widgets/pages.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  double totalHoursWorked = 5;
  double totalPayment = 0;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd, HH:mm:ss');
    final formattedDate = formatter.format(now);

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
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const NotificationsPage(),
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
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
            backgroundColor: Color.fromARGB(255, 194, 255, 191),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DrawerHeader(
                    child: Image.asset('images/sparkslogo.png'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'M E N U',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text('D A S H B O A R D'),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const Dashboard(),
                      ));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text('N O T I F I C A T I O N S'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const NotificationsPage(),
                      ));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.report),
                    title: Text('R E P O R T  F O R M'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ReportPage(),
                      ));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.map),
                    title: Text('P A R K I N G   M A P'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const MapPage(),
                      ));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('S E T T I N G S'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Settings(),
                      ));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('L O G O U T'),
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

          body: SingleChildScrollView(
            //paytopark
            child: Column(
              children: [
                Card(
                  margin: EdgeInsets.all(10),
                  elevation: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'PARK TO PAY',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Time Started: $formattedDate',
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Time Ended: $formattedDate ',
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              child: Text(
                                'Total Hours: $totalHoursWorked',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Total Payment:',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '$totalPayment',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                //AVAILABLE PARKING SPACE BANNER
                Column(
                  children: [
                    Container(
                      width: 500,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          'AVAILABLE PARKING SPACE',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

double totalhours(int hours) {
  double totalHoursWorked = 5;
  int initialPay = 20;
  int addTime = 10;
  int Total = 0;

  for (int i = 0; 1 < hours; i++) {
    if (i < 3) {
      Total = initialPay;
    } else {
      initialPay += Total + addTime;
    }
  }
  return totalHoursWorked;
}
