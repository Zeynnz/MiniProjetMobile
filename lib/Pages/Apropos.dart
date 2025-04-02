import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class Apropos extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.aboutUs)),
      body: Center(
        child: Text(
          "Coiffet Mathéo, Eliott Née-Chirol",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
