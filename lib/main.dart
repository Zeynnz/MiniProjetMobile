import 'package:GameStar/Pages/Accueil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Game Star',
        theme: ThemeData(
          primarySwatch: Colors.green,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.teal,
          ),
          scaffoldBackgroundColor: Colors.white10,
        ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('fr')
      ],
      home: const Accueil()
    );
  }
}
