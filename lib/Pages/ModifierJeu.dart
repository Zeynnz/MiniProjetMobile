import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class ModifierJeu extends StatefulWidget {
  final int index;
  final String nom;
  final double note;
  final bool termine;
  final String description;

  ModifierJeu({
    required this.index,
    required this.nom,
    required this.note,
    required this.termine,
    required this.description,
  });

  @override
  _ModifierJeuState createState() => _ModifierJeuState();
}

class _ModifierJeuState extends State<ModifierJeu> {
  late TextEditingController _nomController;
  late TextEditingController _noteController;
  late TextEditingController _descriptionController;
  bool? _fini;

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.nom);
    _noteController = TextEditingController(text: widget.note.toString());
    _descriptionController = TextEditingController(text: widget.description);
    _fini = widget.termine;
  }

  Future<void> modifierJeu() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/jeux.csv';
      final file = File(filePath);

      if (!file.existsSync()) return;

      String fileContent = await file.readAsString();
      List<List<dynamic>> jeuxList = const CsvToListConverter().convert(fileContent);

      if (widget.index < 0 || widget.index >= jeuxList.length) return;

      jeuxList[widget.index] = [
        _nomController.text.trim(),
        double.tryParse(_noteController.text) ?? 0.0,
        _fini ?? false,
        _descriptionController.text.trim()
      ];

      String csvData = const ListToCsvConverter().convert(jeuxList);
      await file.writeAsString(csvData, flush: true);

      Navigator.pop(context, true);
    } catch (e) {
      print(AppLocalizations.of(context)!.erreurModification);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.modifierTitre),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nomController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.nomJeu,
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _noteController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.noteJeu,
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 16),
            SwitchListTile(
              title: Text(AppLocalizations.of(context)!.end, style: TextStyle(color: Colors.white)),
              value: _fini ?? false,
              onChanged: (value) {
                setState(() {
                  _fini = value;
                });
              },
              activeColor: Colors.blue,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.descriptionFalc,
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: modifierJeu,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(
                  AppLocalizations.of(context)!.enregistrer,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      ));
  }
}
