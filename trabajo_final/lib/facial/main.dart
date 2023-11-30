import 'package:trabajo_final/facial/locator.dart';
import 'package:trabajo_final/facial/pages/submain.dart';

import 'package:flutter/material.dart';

void main() async {
  setupService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FaceRecognition',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SubMainPage(),
    );
  }
}
