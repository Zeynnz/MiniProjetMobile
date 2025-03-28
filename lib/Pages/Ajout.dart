import 'dart:io';
import 'package:GameStar/widgets/saisie.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';


class Ajout extends StatefulWidget {
  @override
  _AjoutState createState() => _AjoutState();
}

class _AjoutState extends State<Ajout> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  bool? _fini; // Valeur du radio bouton (true = Oui, false = Non)

  Future<void> ajouterJeu() async {
    String name = _nomController.text.trim();
    double? note = double.tryParse(_noteController.text);

    if (name.isEmpty || note == null || _fini == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs.")),
      );
      return;
    }

    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/jeux.csv';
      final file = File(filePath);

      List<List<dynamic>> lignes = [];

      // Si le fichier existe, lis le contenu existant
      if (file.existsSync()) {
        String existingContent = await file.readAsString();
        List<List<dynamic>> existingRows = const CsvToListConverter().convert(existingContent);
        lignes.addAll(existingRows);
      } else {
        // Ajouter l'en-tête seulement si le fichier n'existe pas encore
        lignes.add(['Nom', 'Note', 'Terminé']);
      }

      // Ajouter la nouvelle ligne
      lignes.add([name, note, _fini!]);

      // Réécrire tout le fichier CSV
      String csvData = const ListToCsvConverter().convert(lignes);
      await file.writeAsString(csvData, flush: true);

      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Jeu ajouté avec succès !")),
      );

      // Réinitialiser les champs
      setState(() {
        _nomController.clear();
        _noteController.clear();
        _fini = null;
      });
    } catch (e) {
      print("Erreur lors de la sauvegarde : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors de l'ajout du jeu.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ajout de jeux")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            saisie(
              poidsController: _nomController,
              tailleController: _noteController,
              ended: _fini,
              onEndedChanged: (bool? value) {
                setState(() {
                  _fini = value; // Mettre à jour l'état du radio bouton
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: ajouterJeu,
              child: const Text(
                'Ajouter',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
