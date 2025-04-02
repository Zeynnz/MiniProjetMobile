import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:GameStar/Pages/Ajout.dart';
import 'package:GameStar/Pages/Apropos.dart';
import 'package:GameStar/Pages/DetailJeu.dart';
import 'package:GameStar/Pages/ModifierJeu.dart';

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  List<List<dynamic>> jeux = [];

  Future<void> recupererJeux() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/jeux.csv';
      final file = File(filePath);

      if (!file.existsSync()) {
        setState(() {
          jeux = [];
        });
        return;
      }

      String fileContent = await file.readAsString();
      List<List<dynamic>> jeuxList = const CsvToListConverter().convert(fileContent);

      setState(() {
        jeux = jeuxList.map((jeu) {
          jeu[1] = double.tryParse(jeu[1].toString()) ?? 0.0;
          return jeu;
        }).toList();
      });
    } catch (e) {
      setState(() {
        jeux = [];
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

  Color getColorByNote(double note) {
    if (note <= 4) return Colors.red;
    if (note <= 6) return Colors.deepOrange;
    if (note <= 8) return Color(0xFFFF7A55);
    if (note <= 10) return Colors.orangeAccent;
    if (note <= 12) return Colors.lightGreenAccent;
    if (note <= 16) return Colors.lightGreen;
    if (note < 20) return Color(0xFF66BB6A);
    return Colors.green;
  }

  @override
  void initState() {
    super.initState();
    recupererJeux();
  }



  @override
  Widget build(BuildContext context) {
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    List<List<dynamic>> lowNotes = jeux.where((jeu) => (jeu[1] ?? 0.0) <= 10).toList();
    List<List<dynamic>> highNotes = jeux.where((jeu) => (jeu[1] ?? 0.0) > 10).toList();

    return Scaffold(
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
              bool shouldRefresh = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Ajout()),
              ) ??
                  false;
              if (shouldRefresh) recupererJeux();
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: jeux.isEmpty
          ? Center(child: CircularProgressIndicator())
          : isPortrait
          ? ListView.builder(
        itemCount: jeux.length,
        itemBuilder: (context, index) => buildGameCard(jeux[index]),
      )
          : Row(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: lowNotes.length,
              itemBuilder: (context, index) => buildGameCard(lowNotes[index]),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: highNotes.length,
              itemBuilder: (context, index) => buildGameCard(highNotes[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGameCard(List<dynamic> jeu) {
    double note = jeu[1] ?? 0.0;
    bool termine = jeu[2].toString().toLowerCase() == 'true';
    Color cardColor = getColorByNote(note);

    return Card(
      color: cardColor,
      child: ListTile(
        title: Text(jeu[0] ?? AppLocalizations.of(context)!.nomInconnu),
        subtitle: Text('${AppLocalizations.of(context)!.note2} ${jeu[1]}, ${AppLocalizations.of(context)!.termine2} ${termine ? AppLocalizations.of(context)!.oui : AppLocalizations.of(context)!.non}'),
        onLongPress: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                padding: EdgeInsets.all(16.0),
                child: Wrap(
                  children: [
                    ListTile(
                      leading: Icon(Icons.abc),
                      title: Text(AppLocalizations.of(context)!.details),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Detailjeu(
                              nom: jeu[0],
                              note: jeu[1],
                              termine: jeu[2].toString().toLowerCase() == 'true',
                              description: jeu.length > 3 ? jeu[3] : "",
                            ),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.edit),
                      title: Text(AppLocalizations.of(context)!.modifier),
                      onTap: () async {
                        Navigator.pop(context);
                        bool shouldRefresh = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ModifierJeu(
                              index: jeux.indexOf(jeu),
                              nom: jeu[0],
                              note: jeu[1],
                              termine: jeu[2].toString().toLowerCase() == 'true',
                              description: jeu.length > 3 ? jeu[3] : "",
                            ),
                          ),
                        ) ??
                            false;
                        if (shouldRefresh) recupererJeux();
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.delete),
                      title: Text(AppLocalizations.of(context)!.supprimer),
                      onTap: () {
                        SupprimerJeu(jeux.indexOf(jeu)); // Supprime le jeu sélectionné
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
  }
}
