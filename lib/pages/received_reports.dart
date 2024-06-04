// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/pages/login.dart';
import 'package:sparks/pages/report_overview.dart';
import 'package:sparks/widgets/pages.dart';
import 'package:http/http.dart' as http;

class ReceivedReports extends StatefulWidget {
  const ReceivedReports({super.key});

  @override
  State<ReceivedReports> createState() => _ReceivedReportState();
}

class _ReceivedReportState extends State<ReceivedReports> {
  late String token;
  late dynamic userRepList = [];

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final storage = FlutterSecureStorage();
    String? retrievedToken = await storage.read(key: 'token');
    if (retrievedToken != null) {
      setState(() {
        token = retrievedToken;
      });
      await getReportList();
    } else {
      setState(() {
        if (mounted) {
          Navigator.push(
            context,
            PageTransition(child: LoginPage(), type: PageTransitionType.fade),
          );
        }
      });
    }
  }

  void readReport(id) async {
    var json = jsonEncode({
      'id': id,
    });
    final body = json;
    final headers = {'Content-Type': 'application/json'};
    final uri = Uri.parse('http://192.168.254.104:5173/api/readasUserReport');
    try {
      var client = http.Client();
      await client.post(uri, body: body, headers: headers);
      await getReportList();
    } catch (error) {
      // Handle network errors or exceptions
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'An error occurred. Please check your connection and try again.'),
          ),
        );
      }
    }
  }

  Future<dynamic> getReportList() async {
    var json = jsonEncode({
      'token': token,
    });
    final body = json;
    final headers = {'Content-Type': 'application/json'};
    final uri =
        Uri.parse('http://192.168.254.104:5173/api/getUserReceivedReport');
    try {
      var client = http.Client();
      final response = await client.post(uri, body: body, headers: headers);
      dynamic reportList = jsonDecode(response.body);
      setState(() {
        userRepList = reportList['row'];
      });
    } catch (error) {
      // Handle network errors or exceptions
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'An error occurred. Please check your connection and try again.'),
          ),
        );
      }
      return 500;
    }
  }

  Widget _reportList() {
    return ListView.separated(
        itemCount: userRepList.length,
        separatorBuilder: (context, index) => const SizedBox(
              height: 0,
            ),
        itemBuilder: (_, index) {
          String reportDescription =
              userRepList[index]['description'].length > 30
                  ? userRepList[index]['description'].substring(0, 30) + '.....'
                  : userRepList[index]['description'];
          dynamic evidence = userRepList[index]['evidences'];
          int numOfEvidence = jsonDecode(evidence).length;
          return InkWell(
            onTap: () => {
              readReport(userRepList[index]['id']),
              Navigator.push(
                context,
                PageTransition(
                    child: ReportOverview(
                      report: userRepList[index],
                    ),
                    type: PageTransitionType.fade),
              )
            },
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black)),
                    color: userRepList[index]['user_unread'] == 0
                        ? Colors.lightBlue.shade100
                        : Colors.white,
                  ),
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      const Icon(
                        size: 40,
                        Icons.file_copy_rounded,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userRepList[index]['plate'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black),
                            ),
                            Text(reportDescription),
                            Text(
                              '$numOfEvidence submitted images',
                              style: TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(userRepList[index]['date']),
                          Text(userRepList[index]['hour'])
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PagesBackground(),
        Scaffold(
            backgroundColor: Color.fromARGB(0, 255, 255, 255),
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(150),
              child: AppBar(
                iconTheme: IconThemeData(color: Colors.white),
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: const Text(
                  'Received Reports',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            body: _reportList())
      ],
    );
  }
}
