import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: PopupMenuButton<int>(
          icon:Icon(Icons.menu),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 1,
              child: Text('A propos'),
            ),
            PopupMenuItem(
                value: 2,
                child: Text("Je sais aps encore"))
          ],
        ),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.add))
        ],//actions
      )
    );
  }
}