import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//register and login boxform
const BoxDecoration reg = BoxDecoration(
    color: Colors.white70,
    borderRadius: BorderRadius.all(
      Radius.circular(20),
    ));

ButtonStyle greenButton = ButtonStyle(
  elevation: MaterialStatePropertyAll(10),
  backgroundColor:
      MaterialStateProperty.all<Color>(const Color.fromARGB(255, 74, 245, 80)),
  minimumSize: MaterialStateProperty.all<Size>(Size(100, 0)),
);
ButtonStyle whiteButton = ButtonStyle(
  elevation: MaterialStatePropertyAll(10),
  backgroundColor:
      MaterialStateProperty.all<Color>(Color.fromARGB(255, 255, 255, 255)),
  minimumSize: MaterialStateProperty.all<Size>(Size(100, 0)),
);
