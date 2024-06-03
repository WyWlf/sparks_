// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/pages/login.dart';
import 'package:sparks/pages/received_reports.dart';
import 'package:sparks/pages/report_overview.dart';
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

bool _isFormVisible = false;
List<File> _selectedImages = [];

class _ReportPageState extends State<ReportPage> {
  late String token;
  late dynamic userRepList = [];
  dynamic localObj = [];
  bool uploadFail = false;
  TextEditingController plate = TextEditingController();
  TextEditingController description = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  void _pickImages() async {
    final imagePicker = ImagePicker();
    final List<XFile> images = await imagePicker.pickMultiImage();

    int totalSize = 0;

    for (var image in images) {
      File file = File(image.path);
      int imageSize = await file.length();
      if (totalSize + imageSize <= 10 * 1024 * 1024) {
        setState(() {
          _selectedImages.add(file);
          totalSize += imageSize;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image size exceeds 5MB limit.'),
          ),
        );
        break;
      }
    }
  }

  Future<void> _uploadIMGbb() async {
    for (int i = 0; i < _selectedImages.length; i++) {
      try {
        List<int> imageBytes = await _selectedImages[i].readAsBytes();
        String base64image = base64Encode(imageBytes);

        // Upload image to ImgBB API
        var url = Uri.parse('https://api.imgbb.com/1/upload');
        var request = http.MultipartRequest(
          'POST',
          url,
        );
        request.fields['key'] = 'c66e7ce9eea38f9483786e41cb5caaaf';
        request.files.add(http.MultipartFile.fromString(
          'image',
          base64image,
        ));

        var streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);
        var data = jsonDecode(response.body);
        if (data['success'] && data['status'] == 200) {
          var imageUrl = data['data']['url'];
          localObj.add({'image': imageUrl});
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Image ${i + 1} Uploaded...'),
                duration: Duration(milliseconds: 500),
              ),
            );
          }
        } else {
          // Handle error from ImgBB upload request
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Upload failed. Error code: ${data['status']}. Image: ${i + 1}'),
              ),
            );
          }
          uploadFail = true;
          break;
        }
      } catch (error) {
        // Handle errors reading image bytes or uploading to ImgBB
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Upload failed. Error code: $error'),
            ),
          );
        }
      }
    }
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

  Future<dynamic> getReportList() async {
    var json = jsonEncode({
      'token': token,
    });
    final body = json;
    final headers = {'Content-Type': 'application/json'};
    final uri = Uri.parse('http://192.168.1.10:5173/api/getUserReportList');
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

  Future<int> submitFullForm() async {
    plate.text = plate.text.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    plate.text = plate.text.toUpperCase();
    var json = jsonEncode({
      'token': token,
      'plate': plate.text,
      'description': description.text,
      'files': localObj,
    });

    final uri = Uri.parse('http://192.168.1.10:5173/api/addReportForm');
    final body = json;
    final headers = {'Content-Type': 'application/json'};

    try {
      var client = http.Client();
      final response = await client.post(uri, body: body, headers: headers);

      return response.statusCode;
    } catch (error) {
      // Handle network errors or exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'An error occurred. Please check your connection and try again.'),
        ),
      );
      return 500;
    }
  }

  Widget _reportForm() {
    
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Text('Report Information',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

            //reported plate number
            TextField(
              controller: plate,
              decoration: InputDecoration(
                labelText: 'Plate number of the involved vehicle',
              ),
            ),

            //concerns
            TextField(
              controller: description,
              minLines: 1,
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: 'Describe the problem',
              ),
            ),

            //upload evidences

            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line

                children: [
                  Text('Submit Photo Evidences',
                      style: TextStyle(fontSize: 15)),

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
                                onTap: () {
                                  setState(() {
                                    _pickImages();
                                  });
                                },
                              ),

                              // Open Camera
                              // ListTile(
                              //   leading: Icon(Icons.camera),
                              //   title: Text('Open Camera'),
                              //   onTap: () async {

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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Wrap(
                  // Wrap the images for row-based layout
                  spacing: 10, // Adjust spacing between images
                  runSpacing: 10, // Adjust spacing between rows
                  children: _selectedImages.map((image) {
                    return Stack(
                      children: [
                        SizedBox(
                          height: 100,
                          child: Image.file(image),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                //confirm
                MaterialButton(
                  height: 40,
                  color: Color.fromARGB(255, 18, 229, 28),
                  splashColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  elevation: 5,
                  onPressed: () async {
                    if (description.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Please enter a description')));
                      return;
                    }

                    if (plate.text.isEmpty ||
                        !RegExp(r"^[a-zA-Z0-9]+$").hasMatch(plate.text)) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Invalid plate number! Please enter a valid alphanumeric plate number.'),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 3),
                      ));
                      return;
                    }

                    // Show loading indicator
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) => Center(
                        child: LoadingAnimationWidget.halfTriangleDot(
                            color: Colors.green, size: 40),
                      ),
                    );

                    try {
                      // Call your API upload function with appropriate error handling
                      // final response =
                      _uploadIMGbb().then((value) async {
                        int response = await submitFullForm();
                        if (response == 200) {
                          await _loadToken();
                          setState(() {
                            plate.clear();
                            description.clear();
                            localObj = [];
                            uploadFail = true;
                            _selectedImages = [];
                            _isFormVisible = false;
                          });
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Report uploaded successfully!'),
                              ),
                            );
                          }
                        } else {
                          if (mounted) {
                            localObj = [];
                            uploadFail = true;
                            _selectedImages = [];
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Report upload failed!. Please try again.'),
                              ),
                            );
                          }
                        }
                        // Handle successful upload
                        Navigator.pop(context); // Hide loading indicator
                      });
                    } catch (error) {
                      // Handle upload error
                      Navigator.pop(context); // Hide loading indicator
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Error uploading form: $error')));
                    }
                  },
                  child: Text('Submit '),
                ),
                //cancel button
                MaterialButton(
                  height: 40,
                  color: Color.fromARGB(255, 247, 246, 246),
                  splashColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  elevation: 5,
                  onPressed: () {
                    setState(() {
                      _isFormVisible = false;
                    });
                  },
                  child: Text('Cancel'),
                ),
              ],
            ),
          ],
        ));
  }

  Widget _reportList() {
    return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
      Padding(
        padding: EdgeInsets.all(8),
        child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                    child: ReceivedReports(), type: PageTransitionType.fade),
              );
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.horizontal(),
                      side: BorderSide(color: Colors.black54))),
              backgroundColor: MaterialStatePropertyAll(Colors.white),
            ),
            child: Text('View Received Reports',
                style: TextStyle(color: Colors.black))),
      ),
      Expanded(
          child: ListView.separated(
              itemCount: userRepList.length,
              separatorBuilder: (context, index) => const SizedBox(
                    height: 0,
                  ),
              itemBuilder: (_, index) {
                String reportDescription =
                    userRepList[index]['description'].length > 30
                        ? userRepList[index]['description'].substring(0, 30) +
                            '.....'
                        : userRepList[index]['description'];
                dynamic evidence = userRepList[index]['evidences'];
                int numOfEvidence = jsonDecode(evidence).length;
                return InkWell(
                  onTap: () => {
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
                          border:
                              Border(bottom: BorderSide(color: Colors.black)),
                          color: Colors.white,
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
                                        color: const Color.fromARGB(
                                            255, 17, 115, 196)),
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
              }))
    ]);
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
                  'Filed Reports',
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
                if (!_isFormVisible) {
                  setState(() {
                    _isFormVisible = !_isFormVisible;
                  });
                }
              },
              child: const Icon(
                Icons.upload_file_sharp,
                color: Colors.black,
              ),
            ),
            body: _isFormVisible ? _reportForm() : _reportList())
      ],
    );
  }
}
