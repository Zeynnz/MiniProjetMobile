import 'package:flutter/material.dart';

class Apropos extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Page Trois")),
      body: Center(
        child: Text(
          "Coiffet Mathéo, Eliott Née-Chirol",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
