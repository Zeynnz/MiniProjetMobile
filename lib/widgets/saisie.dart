import 'package:flutter/material.dart';

class saisie extends StatelessWidget {
  final TextEditingController poidsController;
  final TextEditingController tailleController;
  final bool? ended;
  final ValueChanged<bool?> onEndedChanged;

  const saisie({
    super.key,
    required this.poidsController,
    required this.tailleController,
    required this.ended,
    required this.onEndedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: poidsController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Nom du jeu',
                hintText: 'Entrez le nom du jeu',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: tailleController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Note',
                hintText: 'Entre 0 et 20',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(
                  child: ListTile(
                    title: const Text('Oui'),
                    leading: Radio<bool>(
                      value: true,
                      groupValue: ended,
                      onChanged: onEndedChanged,
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text('Non'),
                    leading: Radio<bool>(
                      value: false,
                      groupValue: ended,
                      onChanged: onEndedChanged,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
