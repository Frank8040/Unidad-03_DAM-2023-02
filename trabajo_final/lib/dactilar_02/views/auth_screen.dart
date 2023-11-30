// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trabajo_final/dactilar_02/views/home_screen.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class LocalAuthScreen extends StatefulWidget {
  const LocalAuthScreen({Key? key}) : super(key: key);
  @override
  State<LocalAuthScreen> createState() => _LocalAuthScreenState();
}

class _LocalAuthScreenState extends State<LocalAuthScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  Future<void> authinticate() async {
    try {
      final bool didAuthenticate = await auth.authenticate(
        localizedReason:
            'Por favor autentíquese para mostrar el saldo de la cuenta',
        options: const AuthenticationOptions(useErrorDialogs: false),
      );
      if (didAuthenticate == true) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    } on PlatformException catch (e) {
      if (e.code == auth_error.notEnrolled) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error de autenticación'),
              content: const Text(
                  'No se ha configurado la autenticación biométrica en este dispositivo.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
      } else if (e.code == auth_error.lockedOut ||
          e.code == auth_error.permanentlyLockedOut) {
        // Manejar el caso en el que el usuario está bloqueado o bloqueado permanentemente.
        // Puedes mostrar un mensaje al usuario indicando que la autenticación biométrica está temporalmente bloqueada.
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error de autenticación'),
              content: const Text(
                  'La autenticación biométrica está temporalmente bloqueada. Inténtalo más tarde.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
      } else {
        // Manejar otros errores de autenticación.
        // Puedes mostrar un mensaje de error genérico al usuario.
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error de autenticación'),
              content: const Text(
                  'Se produjo un error durante la autenticación biométrica.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplicación de billetera'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Bienvenido a la aplicación de billetera',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          Center(
            child: ElevatedButton(
              child: const Text('Mi saldo de billetera'),
              onPressed: () => authinticate(),
            ),
          )
        ],
      ),
    );
  }
}
