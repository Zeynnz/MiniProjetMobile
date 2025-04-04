import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter/material.dart';

class Detailjeu extends StatelessWidget {
  final String nom;
  final double note;
  final bool termine;
  final String description;

  Detailjeu({
    required this.nom,
    required this.note,
    required this.termine,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87, // Fond sombre
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.detailGame),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(AppLocalizations.of(context)!.nomJeu, nom),
            SizedBox(height: 16),
            _buildInfoRow(AppLocalizations.of(context)!.note, note.toString()),
            SizedBox(height: 16),
            _buildInfoRow(AppLocalizations.of(context)!.end, termine ? "Oui" : "Non"),
            SizedBox(height: 16),
            _buildInfoRow("Description", description.isNotEmpty ? description : "Aucune description"),
          ],
        ),
      ),
      ));
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
