import 'dart:io';

import 'package:GameStar/Pages/Ajout.dart';
import 'package:GameStar/Pages/Apropos.dart';
import 'package:GameStar/Pages/DetailJeu.dart';
import 'package:GameStar/Pages/ModifierJeu.dart';
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
        print(AppLocalizations.of(context)!.fichierInexistant);
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
      print('${AppLocalizations.of(context)!.erreurRecup} : $e');
      setState(() {
        jeux = [];  // En cas d'erreur, retourner une liste vide
      });
    }
  }

  Future<void> SupprimerJeu(int index) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/jeux.csv';
      final file = File(filePath);

      if (!file.existsSync()) return; // Vérifie si le fichier existe

      String fileContent = await file.readAsString();
      List<List<dynamic>> jeuxList = const CsvToListConverter().convert(fileContent);

      // Vérifier si l'index est valide avant de supprimer
      if (index < 0 || index >= jeuxList.length) return;

      jeuxList.removeAt(index); // Supprime l'élément à l'index donné

      // Réécriture du fichier sans l’élément supprimé
      String csvData = const ListToCsvConverter().convert(jeuxList);
      await file.writeAsString(csvData, flush: true);

      // Mettre à jour l'affichage
      setState(() {
        jeux = jeuxList;
      });

      // Afficher un message de confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Jeu supprimé avec succès !")),
      );
    } catch (e) {
      print("Erreur lors de la suppression : $e");
    }
  }


  Color getColorByNote(double note){
    if(note <= 4){
      return Colors.red;
    }else if (note>4 && note <= 6){
      return Colors.deepOrange;
    }else if (note >6 && note <= 8){
      return Color(0xFFFF7A55);
    }else if (note>8 && note <= 10){
      return Colors.orangeAccent;
    }else if (note>10 && note <= 12){
      return Colors.lightGreenAccent;
    }else if (note>12 && note <= 16){
      return Colors.lightGreen;
    }else if (note>16 && note <20){
      return Color(0xFF66BB6A);
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
            )

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
                subtitle: Text('${AppLocalizations.of(context)!.note2} ${jeu[1]}, ${AppLocalizations.of(context)!.termine2} ${termine ? AppLocalizations.of(context)!.oui : AppLocalizations.of(context)!.non}'),
                onLongPress: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        padding: EdgeInsets.all(16.0),
                        child: Wrap(
                          children: [ListTile(
                            leading: Icon(Icons.abc),
                            title: Text("Details"),
                            onTap: () async {
                              Navigator.pop(context); // Ferme le menu contextuel

                              // Envoi des données à la page DetailJeu
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Detailjeu(
                                    nom: jeu[0], // Nom du jeu
                                    note: jeu[1], // Note du jeu
                                    termine: jeu[2].toString().toLowerCase() == 'true', // Statut terminé
                                    description: jeu.length > 3 ? jeu[3] : "", // Description (si présente)
                                  ),
                                ),
                              );
                            },
                          ),
                            ListTile(
                              leading: Icon(Icons.edit),
                              title: Text(AppLocalizations.of(context)!.modifier),
                              onTap: () async {
                                Navigator.pop(context); // Fermer le menu
                                bool shouldRefresh = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ModifierJeu(
                                      index: index,
                                      nom: jeu[0],
                                      note: jeu[1],
                                      termine: jeu[2].toString().toLowerCase() == 'true',
                                      description: jeu.length > 3 ? jeu[3] : "", // Vérifier si la description existe
                                    ),
                                  ),
                                ) ?? false;

                                if (shouldRefresh) {
                                  recupererJeux(); // Rafraîchir la liste après modification
                                }
                              },

                            ),
                            ListTile(
                              leading: Icon(Icons.delete),
                              title: Text(AppLocalizations.of(context)!.supprimer),
                              onTap: () {
                                SupprimerJeu(index); // Supprime le jeu sélectionné
                                Navigator.pop(context); // Ferme le menu
                              },

                            ),
                          ],
                        ),
                      );
                    },
                  );
                },

              ),
            );
          },
        ),
      ),
    );
  }
}
