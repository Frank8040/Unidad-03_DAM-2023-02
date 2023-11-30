import 'package:flutter/material.dart';
import 'package:trabajo_final/dactilar_02/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Autenticación de huellas dactilares'),
    );
  }
}


