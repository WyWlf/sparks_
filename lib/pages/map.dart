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
  List<NavigationItem> floorList = [];
  void parkingSpaces() async {
    setState(() {
      loading = true;
    });
    final uri =
        Uri.parse('https://optimistic-grass-92004.pktriot.net/api/getParkingFloors');
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
        populateFloorList();
        getImages();
      });
    } catch (error) {
      print(error);
    }
  }

  void populateFloorList() {
    floorList = [];
    List<dynamic> a = floors['row'];
    List<dynamic> b = [];

    for (var element in a) {
      b.add(element['floor_name']);
    }
    for (var element in b) {
      floorList.add(NavigationItem(icon: Icons.map, label: element));
    }
  }

  Widget navBar() {
    if (floorList.length >= 2) {
      return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentFloor,
        onTap: (thisIdx) {
          setState(() {
            currentFloor = thisIdx;
            parkingSpaces();
          });
        },
        items: floorList.map((item) {
          return BottomNavigationBarItem(
              icon: Icon(item.icon), label: item.label);
        }).toList(),
      );
    } else {
      return const SizedBox();
    }
  }

  void getImages() async {
    _floorImages = [];
    final uri =
        Uri.parse('https://optimistic-grass-92004.pktriot.net/api/getParkingImages');
    final body = jsonEncode({
      'imageName': floors['sections'],
      'id': floors['row'][currentFloor]['id']
    });
    final headers = {'Content-Type': 'application/json'};
    try {
      final response = await http.post(uri, body: body, headers: headers);
      var json = jsonDecode(response.body);
      setState(() {
        _floorImages = json['imageList'];
        loading = false;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    parkingSpaces();
    super.initState();
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!loading) {
      Navigator.of(context).pop();
    }

    if (floors.isNotEmpty) {
      availableSlots = floors['row'][currentFloor]['max_space'] -
          floors['row'][currentFloor]['used_space'];
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
          body: Column(
            children: [
              Text('Available slots: ' '$availableSlots',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                  child: ListView.separated(
                      itemCount: _floorImages.length,
                      separatorBuilder: (context, index) => const SizedBox(
                            height: 25,
                          ),
                      itemBuilder: (_, index) {
                        return Column(
                          children: [
                            Text(
                              'Section $index',
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Image.memory(base64Decode(_floorImages[index]))
                          ],
                        );
                      }))
            ],
          ),
          bottomNavigationBar: navBar(),
        ),
      ],
    );
  }
}

class NavigationItem {
  final IconData icon;
  final String label;

  NavigationItem({required this.icon, required this.label});
}
