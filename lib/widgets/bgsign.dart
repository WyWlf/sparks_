import 'package:flutter/material.dart';

class BackgroundSign extends StatelessWidget {
  const BackgroundSign({super.key});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [
          Color.fromARGB(255, 237, 253, 236),
          Color.fromARGB(255, 194, 255, 191)
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.center,
      ).createShader(bounds),
      blendMode: BlendMode.darken,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/main.png"), fit: BoxFit.cover
              // ,
              // colorFilter: ColorFilter.mode(
              //Color.fromARGB(31, 0, 5, 2), BlendMode.overlay)
              ),
        ),
      ),
    );
  }
}
