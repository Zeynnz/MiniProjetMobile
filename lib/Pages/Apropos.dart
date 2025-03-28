import 'package:flutter/material.dart';

class Apropos extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("A propos")),
      body: Center(
        child: Text(
          "Coiffet Mathéo, Eliott Née-Chirol",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
