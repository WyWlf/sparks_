import 'dart:async';
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
  late Timer _timer;
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
    final uri = Uri.parse('http://192.168.254.104:5173/api/getParkingFloors');
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
    final uri = Uri.parse('http://192.168.254.104:5173/api/getParkingImages');
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
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      parkingSpaces();
    });
    super.initState();
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (mounted) {
      if (!loading) {
        Navigator.of(context).pop();
      }
    }

    if (floors.isNotEmpty) {
      availableSlots =
          int.parse(floors['floorInfo'][currentFloor]['max_space']) -
              int.parse(floors['floorInfo'][currentFloor]['used_space']);
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
              Text('Total Available Slots: ' '$availableSlots',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 14,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.car_crash_outlined,
                    color: Colors.blue.shade700,
                    size: 24,
                  ),
                  const Text('Available slots',
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.normal)),
                  const SizedBox(
                    width: 14,
                  ),
                  const Icon(
                    Icons.car_crash_outlined,
                    color: Colors.red,
                    size: 24,
                  ),
                  const Text('Used slots',
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.normal)),
                ],
              ),
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
                        return Container(
                          margin: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                  bottom:
                                      BorderSide(color: Colors.black, width: 1),
                                )),
                                child: Text(
                                  'Section: ${_floorImages[index]['data'][index]['section_name']}',
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.car_crash_outlined,
                                        color: Colors.blue.shade700,
                                        size: 64,
                                      ),
                                      Text(
                                        '${_floorImages[index]['data'][index]['label_count'] - _floorImages[index]['data'][index]['label_used']}',
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.car_crash_outlined,
                                        color: Colors.red,
                                        size: 64,
                                      ),
                                      Text(
                                        ' ${_floorImages[index]['data'][index]['label_used']}',
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
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
