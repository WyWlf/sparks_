import 'package:flutter/material.dart';
import 'package:sparks/pages/reporthistory.dart';
import 'package:sparks/widgets/pages.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String _selectedType = 'damaged';
  bool _isFormVisible = false;
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
          //add new form
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              setState(() {
                _isFormVisible = true;
              });
            },
            child: Icon(Icons.add),
          ),

          body: StatefulBuilder(
            builder: (BuildContext context, StateSetter setInnerState) {
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    //FORM
                    if (_isFormVisible) ...[
                      Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Customer Information',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  PopupMenuButton(
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 1,
                                        child: Text("History"),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ReportHistory()));
                                        },
                                      ),
                                    ],
                                    child: Icon(
                                      Icons.more_vert,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
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
                              SizedBox(
                                height: 20,
                              ),
                              Text('Compliant Information',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Plate number',
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
                                  labelText:
                                      'Specify the issues found in the parking lot',
                                ),
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Evidence',
                                  suffixIcon: Icon(Icons.add_a_photo),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    MaterialButton(
                                      height: 40,
                                      color: Color.fromARGB(255, 247, 246, 246),
                                      splashColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      elevation: 10,
                                      onPressed: () {
                                        setState(() {
                                          _isFormVisible = false;
                                        });
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    MaterialButton(
                                      height: 40,
                                      color: Color.fromARGB(255, 18, 229, 28),
                                      splashColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      elevation: 10,
                                      onPressed: () {},
                                      child: Text('Confirm'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ))
                    ]
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
