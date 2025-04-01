import 'dart:io';
import 'package:GameStar/widgets/saisie.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';


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
        SnackBar(content: Text(AppLocalizations.of(context)!.erreurSnack)),
      );
      return;
    }

    if(note>20 || note<0){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.erreurNote)),
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
      }

      // Ajouter la nouvelle ligne
      lignes.add([name, note, _fini!]);

      // Réécrire tout le fichier CSV
      String csvData = const ListToCsvConverter().convert(lignes);
      await file.writeAsString(csvData, flush: true);

      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.ajout)),
      );

      // Réinitialiser les champs
      setState(() {
        _nomController.clear();
        _noteController.clear();
        _fini = null;
      });

      Navigator.pop(context,true);
    } catch (e) {
      print("${AppLocalizations.of(context)!.erreurSave}$e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.erreurAjout)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.titreAjout)),
      body: Center(child: Padding(
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
              child: Text(
                AppLocalizations.of(context)!.texteAjout,
                style: const TextStyle(fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),)
    );
  }
}
