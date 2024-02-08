import 'package:flutter/material.dart';
import 'package:sparks/widgets/pages.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  int _currentFloor = 0;
  int _availableSlots = 10;

  final List<String> _floorImages = [
    'images/parking_map_floor_1.jpg',
    'images/parking_map_floor_1.jpg',
    'images/parking_map_floor_1.jpg',
  ];

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
                'Parking Map',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              Container(
                width: double.infinity,
                height: 50,
                color: Colors.white.withOpacity(0.8),
                child: Center(
                  child: Text(
                    'Available Slots: $_availableSlots',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Image.asset(_floorImages[_currentFloor]),
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentFloor,
            onTap: (index) {
              setState(() {
                _currentFloor = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.arrow_downward),
                label: 'Floor 1',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.arrow_downward),
                label: 'Floor 2',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.arrow_downward),
                label: 'Floor 3',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
