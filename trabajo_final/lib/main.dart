import 'package:flutter/material.dart';
import 'package:trabajo_final/dactilar/views/login_screen.dart';
import 'package:trabajo_final/dactilar_02/views/auth_screen_click.dart';
import 'package:trabajo_final/facial/locator.dart';
import 'package:trabajo_final/facial/pages/submain.dart';

void main() async {
  setupService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xFF6C63FF),
        hintColor: const Color(0xFF6C63FF),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SubMainPage(),
                  ),
                );
              },
              icon: const Icon(Icons.face),
              label: const Text('Facial'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.fingerprint),
              label: const Text('Dactilar'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AuthScreenClick(),
                  ),
                );
              },
              icon: const Icon(Icons.fingerprint),
              label: const Text('Dactilar Prueba'),
            ),
          ],
        ),
      ),
    );
  }
}
