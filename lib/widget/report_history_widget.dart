import 'package:flutter/material.dart';
import 'package:sparks/models/report_data.dart';

class ReportHistoryWidget extends StatelessWidget {
  final List<ReportData> reports;

  ReportHistoryWidget({required this.reports});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: reports.length,
      itemBuilder: (context, index) {
        ReportData report = reports[index];
        return ListTile(
          title: Text(report.plate),
          subtitle: Text(report.issue),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // Handle delete action
            },
          ),
        );
      },
    );
  }
}
