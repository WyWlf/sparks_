import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sparks/widgets/pages.dart';

class TransactionHistory extends StatefulWidget {
  final String token;
  const TransactionHistory({super.key, required this.token});

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  String get token => widget.token;
  dynamic transactionHistory = [];

  void getHistory() async {
    final uri =
        Uri.parse('http://192.168.1.10:5173/api/userTransactionHistory');
    final body = jsonEncode({'token': token});
    final headers = {'Content-Type': 'application/json'};
    try {
      final response = await http.post(uri, body: body, headers: headers);
      var json = jsonDecode(response.body);
      setState(() {
        if (json['response']) {
          transactionHistory = json['data'];
        } else {
          transactionHistory = [];
        }
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    // Call your method to start fetching transactions and set up the timer
    getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
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
            title: const Text(
              'Parking History',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
          ),
        ),
        body: transactionHistory.length == 0
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("NO TRANSACTION HISTORY")],
                ),
              )
            : ListView.separated(
                itemCount: transactionHistory.length,
                separatorBuilder: (context, index) => Container(
                  height: 0,
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black)),
                    color: Colors.black,
                  ),
                ),
                itemBuilder: (context, index) {
                  // Parse strings into DateTime objects
                  DateTime startTime =
                      DateTime.parse(transactionHistory[index]['timeEntry']);
                  DateTime endTime =
                      DateTime.parse(transactionHistory[index]['timeExit']);

                  // Calculate the difference between the two times
                  Duration difference = endTime.difference(startTime);

                  // Calculate hours and minutes
                  int hours = difference.inHours;
                  int minutes = difference.inMinutes.remainder(
                      60); // Remaining minutes after subtracting hours
                  return Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Time of Entry:'),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${transactionHistory[index]['entryTime']}',
                                    style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 7, 112, 199)),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Time of Exit:'),
                                  const SizedBox(width: 4),
                                  Text(
                                    startTime == endTime
                                        ? 'Currently Parking'
                                        : '${transactionHistory[index]['exitTime']}',
                                    style: const TextStyle(color: Colors.red),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Total time:'),
                                  const SizedBox(width: 4),
                                  Text(
                                    startTime == endTime
                                        ? '-'
                                        : '$hours hour/s & $minutes minute/s',
                                    style: const TextStyle(color: Colors.black),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Fee:'),
                                  const SizedBox(width: 4),
                                  Text(
                                    startTime == endTime
                                        ? '-'
                                        : 'PHP ${transactionHistory[index]['fee'].toStringAsFixed(2)}',
                                    style: const TextStyle(color: Colors.black),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
      ),
    ]);
  }
}
