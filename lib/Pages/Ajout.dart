import 'package:flutter/material.dart';

class Ajout extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("Ajout de jeux")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () { },
              child: const Text(
                'Ajouter',
                style: TextStyle(fontSize: 30.0),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

}