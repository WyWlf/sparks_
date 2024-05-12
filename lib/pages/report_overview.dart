import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sparks/widgets/pages.dart';

class ReportOverview extends StatefulWidget {
  final dynamic report;
  const ReportOverview({super.key, required this.report});

  @override
  State<ReportOverview> createState() => _ReportOverviewState();
}

class _ReportOverviewState extends State<ReportOverview> {
  late dynamic parseReport = [];

  @override
  void initState() {
    super.initState();

    setState(() {
      parseReport = jsonDecode(widget.report['evidences']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      const PagesBackground(),
      Scaffold(
          backgroundColor: const Color.fromARGB(0, 255, 255, 255),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(150),
            child: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Text(
                'Report Overview',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          body: Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Reported Plate Number:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 12),
                      Text('${widget.report['plate']}',
                          style:
                              const TextStyle(fontSize: 16, color: Colors.blue))
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Time reported:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 12),
                      Text(
                          '${widget.report['hour']} / ${widget.report['date']}',
                          style:
                              const TextStyle(fontSize: 16, color: Colors.blue))
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Description:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 12),
                  Row(
                    children: [
                      Flexible(
                          child: Text('${widget.report['description']}',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black)))
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Evidences:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection:
                        Axis.horizontal, // Set horizontal scrolling
                    child: Row(
                      children: List.generate(
                        parseReport.length,
                        (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            width: 500,
                            parseReport[index]['image'].toString(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ))
    ]);
  }
}
