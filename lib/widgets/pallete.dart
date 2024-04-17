import 'package:flutter/material.dart';

const TextStyle titlehead = TextStyle(
  fontFamily: 'Orbitron',
  fontSize: 60,
  fontWeight: FontWeight.bold,
  color: Color.fromARGB(255, 0, 0, 0),
  shadows: [
    Shadow(
      blurRadius: 20.0, // shadow blur
      color: Color.fromARGB(255, 49, 157, 60), // shadow color
      offset: Offset(8.0, 8.0), // how much shadow will be shown
    ),
  ],
);
//logo
const TextStyle logo = TextStyle(
  fontFamily: 'Arial',
  fontSize: 35,
  fontWeight: FontWeight.bold,
  color: Color.fromARGB(255, 0, 0, 0),
  shadows: [
    Shadow(
      blurRadius: 20.0, // shadow blur
      color: Color.fromARGB(255, 195, 255, 201), // shadow color
      offset: Offset(8.0, 8.0), // how much shadow will be shown
    ),
  ],
);

//default fontsize
const TextStyle def = TextStyle(fontSize: 15, color: Colors.black);
//buttonstyle
const TextStyle buttons =
    TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Colors.black);
//textspanstyle
const TextStyle tspan = TextStyle(
    fontSize: 15,
    color: Color.fromARGB(255, 0, 94, 131),
    fontWeight: FontWeight.bold);

//dashboardpallete
const TextStyle white = TextStyle(color: Colors.white);
const TextStyle green = TextStyle(color: Color.fromARGB(255, 67, 229, 4));
const TextStyle amount =
    TextStyle(color: Color.fromARGB(255, 67, 229, 4), fontSize: 25);
const TextStyle AvPark =
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white);
const TextStyle sums = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
const TextStyle labl = TextStyle(fontSize: 12, color: Colors.black);
