import 'package:flutter/material.dart';
import 'package:sparks/widgets/pages.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String _selectedType = 'damaged';
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
                'Report Form',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Nickname',
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Plate number',
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Type of parking lot issue',
                  ),
                  value: _selectedType,
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value!;
                    });
                  },
                  items: [
                    DropdownMenuItem(
                      child: Text('Damaged parking lot'),
                      value: 'damaged',
                    ),
                    DropdownMenuItem(
                      child: Text('Blocked parking lot'),
                      value: 'blocked',
                    ),
                    DropdownMenuItem(
                      child: Text('Other'),
                      value: 'other',
                    ),
                  ],
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Specify the issues found in the parking lot',
                  ),
                ),
                MaterialButton(
                  onPressed: () {},
                  child: Text('Confirm'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
