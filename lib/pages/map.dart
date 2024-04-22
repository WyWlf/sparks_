import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sparks/widgets/pages.dart';
import 'package:http/http.dart' as http;

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  int currentFloor = 0;
  int availableSlots = 0;
  late Map<String, dynamic> floors = {};
  late List<dynamic> _floorImages = [];
  bool loading = true;
  void parkingSpaces() async {
    final uri =
        Uri.parse('https://young-cloud-49021.pktriot.net/api/getParkingFloors');
    try {
      final response = await http.get(uri);
      var json = jsonDecode(response.body);

      if (mounted && loading) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => Center(
            child: LoadingAnimationWidget.halfTriangleDot(
                color: Colors.green, size: 40),
          ),
        );
      }
      setState(() {
        floors = json;
        try {
          getImages();
        } catch (e) {
          print(e);
        } finally {
          Navigator.of(context).pop();
        }
      });
    } catch (error) {
      print(error);
    }
  }

  void getImages() async {
    final uri =
        Uri.parse('https://young-cloud-49021.pktriot.net/api/getParkingImages');
    final body = jsonEncode({'imageName': floors['sections']});
    final headers = {'Content-Type': 'application/json'};
    try {
      final response = await http.post(uri, body: body, headers: headers);
      var json = jsonDecode(response.body);
      setState(() {
        _floorImages = json['imageList'];
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    parkingSpaces();
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(floors);
    if (floors.isNotEmpty) {
      availableSlots =
          floors['row'][0]['max_space'] - floors['row'][0]['used_space'];
    }

    return Stack(
      children: [
        const PagesBackground(),
        Scaffold(
          backgroundColor: const Color.fromARGB(0, 255, 255, 255),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(130),
            child: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 80,
              title: const Text(
                'Parking Area',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          body: ListView.separated(
              itemCount: _floorImages.length,
              separatorBuilder: (context, index) => const Divider(
                    thickness: 0,
                  ),
              itemBuilder: (_, index) {
                return Column(
                  children: [
                    Text(
                      floors['sections'][0]['section_name'],
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Image.memory(base64Decode(_floorImages[index]))
                  ],
                );
              }),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentFloor,
            onTap: (thisIdx) {
              setState(() {
                currentFloor = thisIdx;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.arrow_downward),
                label: 's',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.arrow_downward),
                label: 's',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
