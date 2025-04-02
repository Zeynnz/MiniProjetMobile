import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class saisie extends StatelessWidget {
  final TextEditingController nomController;
  final TextEditingController noteController;
  final bool? ended;
  final ValueChanged<bool?> onEndedChanged;

  const saisie({
    super.key,
    required this.nomController,
    required this.noteController,
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
              controller: nomController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.nomJeu,
                hintText: AppLocalizations.of(context)!.nomJeuHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: noteController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.noteJeu,
                hintText: AppLocalizations.of(context)!.noteJeuHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Text( AppLocalizations.of(context)!.labeltermine,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 18,
              ),),
            Row(
              children: <Widget>[
                Expanded(
                  child: ListTile(
                    title: Text(AppLocalizations.of(context)!.oui),
                    leading: Radio<bool>(
                      value: true,
                      groupValue: ended,
                      onChanged: onEndedChanged,
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(AppLocalizations.of(context)!.non),
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
