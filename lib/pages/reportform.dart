// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sparks/pages/reporthistory.dart';
import 'package:sparks/widgets/pages.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class EncodedImages {
  EncodedImages({required this.index, required this.imgData});

  int index;
  String imgData;

  EncodedImages getObj() {
    return EncodedImages(index: index, imgData: imgData);
  }
}

class _ReportPageState extends State<ReportPage> {
  TextEditingController plate = TextEditingController();
  TextEditingController description = TextEditingController();
  String _selectedType = 'damaged';
  bool _isFormVisible = false;
  List<File> _selectedImages = [];

  Future<List<File>> _pickImages() async {
    if (_selectedImages.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Please wait for the current image selection to complete.'),
        ),
      );
      return _selectedImages;
    }
    final imagePicker = ImagePicker();
    final List<XFile> images = await imagePicker.pickMultiImage();

    if (images == null) {
      return _selectedImages;
    }
    List<File> selectedImages = [];
    int totalSize = 0;

    for (var image in images) {
      File file = File(image.path);
      int imageSize = await file.length();
      if (totalSize + imageSize <= 10 * 1024 * 1024) {
        selectedImages.add(file);
        totalSize += imageSize;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image size exceeds 5MB limit.'),
          ),
        );
        break;
      }
    }

    setState(() {
      _selectedImages = selectedImages;
    });

    return _selectedImages;
  }

  Future<void> _submitForm() async {
    var localObj = [];
    for (var i = 0; i < _selectedImages.length; i++) {
      try {
        List<int> imageBytes = await _selectedImages[i].readAsBytes();
        String base64image = base64Encode(imageBytes);

        // Upload image to ImgBB API
        var url = Uri.parse('https://api.imgbb.com/1/upload');
        var headers = {'Content-Type': 'multipart/form-data'};
        var request = http.MultipartRequest('POST', url);
        request.fields['key'] = '9a1831cc0674af49d4d08b72d378aaa8';
        request.files.add(http.MultipartFile.fromBytes(
          'image',
          imageBytes,
        ));

        var streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (data != null &&
              data['data'] != null &&
              data['data']['url'] != null) {
            var imageUrl = data['data']['url'];
            localObj.add({'image': imageUrl});
          } else {
            // Handle ImgBB upload error
            print('Error uploading image to ImgBB: $data');
          }
        } else {
          // Handle error from ImgBB upload request
          print('Error uploading image: Status code ${response.statusCode}');
        }
      } catch (error) {
        // Handle errors reading image bytes or uploading to ImgBB
        print('Error uploading image: $error');
      }
    }
//data to be posted
    var json = jsonEncode({
      'plate': plate.text,
      'issue': _selectedType,
      'description': description.text,
      'files': localObj,
    });

    print('Test DATA POST: $json');

    final uri =
        Uri.parse('https://young-cloud-49021.pktriot.net/api/addReportForm');
    final body = json;
    final headers = {'Content-Type': 'application/json'};

    try {
      var client = http.Client();
      final response = await client.post(uri, body: body, headers: headers);

      if (response.statusCode == 200) {
        // Registration successful
        // Clear registration form fields
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Report submitted.'),
            ),
          );
        } else {
          return;
        }
      } else {
        // Handle network errors or exceptions
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('An error occurred. ${response.statusCode}'),
            ),
          );
        } else {
          return;
        }
      }
    } catch (error) {
      // Handle network errors or exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'An error occurred. Please check your connection and try again.'),
        ),
      );
    }
  }

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
              title: const Text(
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
            child: const Icon(Icons.add),
          ),

          body: StatefulBuilder(
            builder: (BuildContext context, StateSetter setInnerState) {
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    //FORM
                    if (_isFormVisible) ...[
                      Container(
                          padding: const EdgeInsets.symmetric(
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

                              // //nickname
                              // TextField(
                              //   decoration: InputDecoration(
                              //     labelText: 'Nickname',
                              //   ),
                              // ),

                              //platenumber
                              // TextField(
                              //   controller: plate,
                              //   decoration: InputDecoration(
                              //     labelText: 'Plate number',
                              //   ),
                              // ),

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
                                controller: plate,
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
                                    value: 'damaged',
                                    child: Text('Damaged parking lot'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'blocked',
                                    child: Text('Blocked parking lot'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'other',
                                    child: Text('Other'),
                                  ),
                                ],
                              ),

                              //concerns
                              TextField(
                                controller: description,
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
                                                // ListTile(
                                                //   leading: Icon(Icons.camera),
                                                //   title: Text('Open Camera'),
                                                //   onTap: () async {
                                                //     final images =
                                                //         await _captureImages();
                                                //     setState(() {
                                                //       if (images != null) {
                                                //         _selectedImages =
                                                //             images;
                                                //         _displayedImage = images[
                                                //             0]; // Display the first captured image
                                                //       }
                                                //     });
                                                //   },
                                                // ),
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
                                  Wrap(
                                    // Wrap the images for row-based layout
                                    spacing:
                                        10, // Adjust spacing between images
                                    runSpacing:
                                        10, // Adjust spacing between rows
                                    children: _selectedImages.map((image) {
                                      return Stack(
                                        children: [
                                          Container(
                                            // Use Box for aspect ratio preservation
                                            child: Image.file(image),
                                            height: 100,
                                          ),
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _selectedImages.remove(image);
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
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
                                          plate.clear();
                                          description.clear();
                                          _selectedType = 'damaged';
                                          _selectedImages = [];
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
                                      onPressed: () async {
                                        if (description.text.isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Please enter a description')));
                                          return;
                                        }

                                        if (plate.text.isEmpty ||
                                            !RegExp(r"^[a-z0-9]+$")
                                                .hasMatch(plate.text)) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                'Invalid plate number! Please enter a valid alphanumeric plate number.'),
                                            backgroundColor: Colors.red,
                                            duration:
                                                const Duration(seconds: 3),
                                          ));
                                          return;
                                        }

                                        // Show loading indicator
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) =>
                                              Center(
                                            child: LoadingAnimationWidget
                                                .halfTriangleDot(
                                                    color: Colors.green,
                                                    size: 40),
                                          ),
                                        );

                                        try {
                                          // Call your API upload function with appropriate error handling
                                          final response = await _submitForm();

                                          // Handle successful upload
                                          Navigator.pop(
                                              context); // Hide loading indicator
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Form uploaded successfully!')));
                                        } catch (error) {
                                          // Handle upload error
                                          Navigator.pop(
                                              context); // Hide loading indicator
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Error uploading form: $error')));
                                        }
                                      },
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
