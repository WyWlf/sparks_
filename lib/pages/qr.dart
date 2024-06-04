import 'package:flutter/material.dart';
import 'package:sparks/widgets/pages.dart';

class QR extends StatefulWidget {
  const QR({super.key});

  @override
  State<QR> createState() => _QRSTATE();
}

class _QRSTATE extends State<QR> {
  @override
  void initState() {
    super.initState();
    // Call your method to start fetching transactions and set up the timer
  }

  @override
  Widget build(BuildContext context) {
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
                  'Share',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/qrcode.png"), fit: BoxFit.contain),
              ),
            )),
      ],
    );
  }
}
