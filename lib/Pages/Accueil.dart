import 'dart:io';

import 'package:GameStar/Pages/Ajout.dart';
import 'package:GameStar/Pages/Apropos.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:path_provider/path_provider.dart';

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  // Variable pour stocker les jeux
  List<List<dynamic>> jeux = [];

  // Méthode pour récupérer les jeux
  Future<void> recupererJeux() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/jeux.csv';
      final file = File(filePath);

      // Vérifier si le fichier existe
      if (!file.existsSync()) {
        print("Le fichier n'existe pas");
        setState(() {
          jeux = [];  // Si le fichier n'existe pas, on retourne une liste vide
        });
        return;
      }

      // Lire le contenu du fichier
      String fileContent = await file.readAsString();

      // Convertir le contenu du fichier CSV en liste
      List<List<dynamic>> jeuxList = const CsvToListConverter().convert(fileContent);

      setState(() {
        jeux = jeuxList.map((jeu) {
          jeu[1] = double.tryParse(jeu[1].toString()) ?? 0.0;  // Convertir la note en double, sinon 0.0
          return jeu;
        }).toList(); // Mettre à jour l'état avec les jeux récupérés
      });
    } catch (e) {
      print("Erreur lors de la récupération des jeux : $e");
      setState(() {
        jeux = [];  // En cas d'erreur, retourner une liste vide
      });
    }
  }

  Color getColorByNote(double note){
    if(note <= 8){
      return Colors.red;
    }else if (note >8 && note <= 12){
      return Colors.deepOrange;
    }else if (note>12 && note <= 16){
      return Colors.lightGreenAccent;
    }else if (note>16 && note <20){
      return Colors.lightGreen;
    }else if (note == 20){
      return Colors.green;
    }else {
      return Colors.white;
    }
  }

  @override
  void initState() {
    super.initState();
    recupererJeux();  // Appel de la méthode pour récupérer les jeux dès que l'écran est créé
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Center(child: Text("Game Star")),
        leading: PopupMenuButton<int>(
          icon: Icon(Icons.menu),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 1,
              child: Text(AppLocalizations.of(context)!.aboutUs),
            ),
            PopupMenuItem(
                value: 2,
                child: Text("Je sais pas encore"))
          ],
          onSelected: (value) {
            if (value == 1) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Apropos()));
            }
          },
        ),
        actions: [
          IconButton(
            onPressed: () async {
              // Naviguer vers la page d'ajout et attendre un résultat
              bool shouldRefresh = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Ajout()),
              ) ?? false;

              // Si le jeu a été ajouté, on rafraîchit la liste
              if (shouldRefresh) {
                recupererJeux();
              }
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: Center(
        child: jeux.isEmpty
            ? const CircularProgressIndicator() // Affiche un indicateur de chargement si la liste est vide
            : ListView.builder(
          itemCount: jeux.length,
          itemBuilder: (context, index) {
            var jeu = jeux[index];
            double note = jeu[1] ?? 0.0;
            bool termine = jeu[2].toString().toLowerCase() == 'true';  // Conversion de la chaîne en booléen
            Color cardColor = getColorByNote(note);

            return Card(
              color: cardColor,
              child: ListTile(
                title: Text(jeu[0] ?? "Nom inconnu"),  // Affiche le nom du jeu
                subtitle: Text('Note: ${jeu[1]}, Terminé: ${termine ? 'Oui' : 'Non'}'),
              ),
            );
          },
        ),
      ),
    );
  }
}
