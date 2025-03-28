import 'package:GameStar/Pages/Accueil.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Star',//j'ai pas d'idée donc c'est temporaire
      theme: ThemeData(
        primarySwatch: Colors.green,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
        ),
        scaffoldBackgroundColor: Colors.white10,
      ),
      home: const Accueil(),
    );
  }
}

