import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
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
  List<File?> _selectedImages = [];

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

                              //nickname
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Nickname',
                                ),
                              ),

                              //platenumber
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Plate number',
                                ),
                              ),

                              //title
                              SizedBox(
                                height: 20,
                              ),
                              Text('Compliant Information',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),

                              //reported plate number
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Plate number',
                                ),
                              ),

                              //parking issue
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

                              //concerns
                              TextField(
                                decoration: InputDecoration(
                                  labelText:
                                      'Specify the issues found in the parking lot',
                                ),
                              ),

                              //upload evidences

                              Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceEvenly, // added line

                                  children: [
                                    Text('Submit Evidences',
                                        style: TextStyle(fontSize: 18)),

                                    SizedBox(
                                      width: 100,
                                    ),

                                    //UPLOAD EVIDENCE OPTIONS

                                    IconButton(
                                      icon: Icon(Icons.add_a_photo),
                                      onPressed: () async {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                //OpenGallery
                                                ListTile(
                                                  leading: Icon(Icons.photo),
                                                  title: Text('Open Gallery'),
                                                  onTap: () async {
                                                    final images =
                                                        await _pickImages();
                                                    setState(() {
                                                      _selectedImages = images;
                                                    });
                                                  },
                                                ),

                                                //Open Camera
                                                ListTile(
                                                  leading: Icon(Icons.camera),
                                                  title: Text('Open Camera'),
                                                  onTap: () async {
                                                    final images =
                                                        await _captureImages();
                                                    setState(() {
                                                      _selectedImages = images;
                                                    });
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ]),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                      'Total Images: ${_selectedImages.length}'),
                                  Container(
                                      height: 200,
                                      child: _selectedImages.isNotEmpty
                                          ? Image.file(_selectedImages[0]!)
                                          : Text("No Selected Images")),
                                  Divider(color: Colors.black),
                                ],
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
                                    //cancel button
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

                                    //confirm
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

  Widget _buildImageGrid() {
    return GridView.count(
      crossAxisCount: 3,
      children: _selectedImages.map((image) {
        return Image.file(
          image!,
          fit: BoxFit.cover,
        );
      }).toList(),
    );
  }

  Future<List<File>> _pickImages() async {
    final imagePicker = ImagePicker();
    final List<XFile>? images = await imagePicker.pickMultiImage();
    return images?.map((e) => File(e.path)).toList() ?? [];
  }

  Future _captureImages() async {
    final imagePicker = ImagePicker();
    List<File> images = [];
    for (int i = 0; i < 5; i++) {
      final returnedImage =
          await imagePicker.pickImage(source: ImageSource.camera);
      if (returnedImage != null) {
        images.add(File(returnedImage.path));
      } else {
        break;
      }
    }
    setState(() {
      _selectedImages = images;
    });
  }
}
