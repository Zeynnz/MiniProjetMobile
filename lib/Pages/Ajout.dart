import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';



class Ajout extends StatelessWidget{



  Future<void> AjouterJeu(String name, double note, bool fini) async {
    try {
      // Récupérer le répertoire où stocker le fichier
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/jeux.csv';
      final file = File(filePath);


    } catch (e) {
      print("Erreur lors de la sauvegarde du fichier : $e");
    }
  }

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