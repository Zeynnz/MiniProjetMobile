import 'package:GameStar/Pages/Apropos.dart';
import 'package:flutter/material.dart';

class Accueil extends StatelessWidget {
  const Accueil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Center(child: Text("Game Star")),
        leading: PopupMenuButton<int>(
          icon:Icon(Icons.menu),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 1,
              child: Text('A propos'),
            ),
            PopupMenuItem(
                value: 2,
                child: Text("Je sais pas encore"))
          ],
          onSelected: (value) {
            if(value == 1){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Apropos()),);
            }
          },
        ),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.add))
        ],//actions
      )
    );
  }
}