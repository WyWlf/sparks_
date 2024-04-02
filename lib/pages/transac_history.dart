import 'package:flutter/material.dart';
import 'package:sparks/widgets/pages.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({super.key});

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      PagesBackground(),
      Scaffold(
        backgroundColor: Color.fromARGB(0, 255, 255, 255),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(130),

          //SPARKS
          child: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'History',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("NO TRANSACTION HISTORY")],
          ),
        ),
      ),
    ]);
  }
}
