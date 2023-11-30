// ignore_for_file: prefer_is_not_operator, avoid_print

import 'dart:io';
import 'package:flutter/services.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trabajo_final/dactilar/bloc/login_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_auth/local_auth.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
final TextEditingController _controllerUsername = TextEditingController();
final TextEditingController _controllerPassword = TextEditingController();

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      backgroundColor: Colors.white,
      body: BlocProvider<LoginBloc>(
        create: (BuildContext context) {
          return LoginBloc();
        },
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            _checkStatusLogin(context, state);
          },
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              return Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView(
                          children: <Widget>[
                            const WidgetIconBiking(),
                            const WidgetLabelContinueWith(),
                            const WidgetLoginViaSocialMedia(),
                            const WidgetLabelSignInWithEmail(),
                            WidgetFormLogin(),
                            const WidgetResetPasswordButton(),
                          ],
                        ),
                      ),
                      const WidgetSignUp(),
                    ],
                  ),
                  _checkWidgetStatusLogin(state),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  _checkStatusLogin(BuildContext context, LoginState state) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (state is LoginFailed) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(state.error)),
      );
    } else if (state is LoginSuccess) {
      var localAuth = LocalAuthentication();
      try {
        bool isAuthenticate = await localAuth.authenticate(
            localizedReason: 'Por favor autentíquese para iniciar sesión');
        print('Está autenticado: $isAuthenticate');
      } on PlatformException catch (e) {
        print(e);
      }
    }
  }

  Widget _checkWidgetStatusLogin(LoginState state) {
    if (state is LoginLoading) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
        ),
        child: Center(
          child: Wrap(
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    if (Platform.isIOS)
                      const CupertinoActivityIndicator()
                    else
                      const CircularProgressIndicator(),
                    const SizedBox(height: 16.0),
                    const Text('Espere por favor'),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}

class WidgetIconBiking extends StatelessWidget {
  const WidgetIconBiking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        top: mediaQuery.padding.top > 0 ? mediaQuery.padding.top : 16.0,
        right: 16.0,
      ),
      child: Stack(
        children: <Widget>[
          Center(
            child: Image.asset(
              'assets/images/img_biking.png',
              width: mediaQuery.size.width / 1.5,
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Center(
              child: Text(
                'Biking App',
                style: TextStyle(
                  fontSize: 24.0,
                  fontFamily: 'NanumGothic',
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WidgetLabelContinueWith extends StatelessWidget {
  const WidgetLabelContinueWith({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 16.0),
      child: Center(
        child: Text(
          'Continua con',
          style: TextStyle(
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}

class WidgetLoginViaSocialMedia extends StatelessWidget {
  const WidgetLoginViaSocialMedia({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 8.0, right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildSocialMediaIcon(FontAwesomeIcons.facebookF),
          const SizedBox(width: 32.0),
          _buildSocialMediaIcon(FontAwesomeIcons.google),
          const SizedBox(width: 32.0),
          _buildSocialMediaIcon(FontAwesomeIcons.twitter),
        ],
      ),
    );
  }

  Widget _buildSocialMediaIcon(IconData iconData) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Icon(
        iconData,
        size: 18.0,
        color: Colors.black54,
      ),
    );
  }
}

class WidgetLabelSignInWithEmail extends StatelessWidget {
  const WidgetLabelSignInWithEmail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 28.0),
      child: Center(
        child: Text(
          'O inicia sesión con correo electrónico',
          style: TextStyle(color: Colors.black54),
        ),
      ),
    );
  }
}

class WidgetFormLogin extends StatelessWidget {
  final FocusNode focusNodePassword = FocusNode();

  WidgetFormLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _controllerUsername,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Correo electrónico / Nombre de usuario',
              contentPadding: EdgeInsets.all(16.0),
            ),
            keyboardType: TextInputType.emailAddress,
            enabled: !(loginBloc.close() is LoginLoading),
            textInputAction: TextInputAction.next,
            onSubmitted: (username) {
              FocusScope.of(context).requestFocus(focusNodePassword);
            },
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: _controllerPassword,
            focusNode: focusNodePassword,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Contraseña',
              contentPadding: EdgeInsets.all(16.0),
            ),
            keyboardType: TextInputType.text,
            obscureText: true,
            enabled: !(loginBloc.close() is LoginLoading),
            textInputAction: TextInputAction.done,
            onSubmitted: (password) {
              focusNodePassword.unfocus();
              String username = _controllerUsername.text;
              String password = _controllerPassword.text;
              loginBloc.add(
                LoginEvent(
                  username: username,
                  password: password,
                ),
              );
            },
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                String username = _controllerUsername.text;
                String password = _controllerPassword.text;
                loginBloc.add(
                LoginEvent(
                  username: username,
                  password: password,
                ),
              );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color(0xFF6C63FF),
                ),
              ),
              child: const Text(
                'Iniciar Sesión',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'NanumGothic',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WidgetResetPasswordButton extends StatelessWidget {
  const WidgetResetPasswordButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        children: <Widget>[
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'RESTABLECER LA CONTRASEÑA',
                style: TextStyle(
                  color: Color(0xFF6C63FF),
                  fontFamily: 'NanumGothic',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WidgetSignUp extends StatelessWidget {
  const WidgetSignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom:
            mediaQuery.padding.bottom > 0 ? mediaQuery.padding.bottom : 16.0,
      ),
      child: Center(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '¿No tienes una cuenta? ',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextSpan(
                text: 'Registrate aquí',
                style: Theme.of(context).textTheme.bodyMedium?.merge(
                      const TextStyle(
                        color: Color(0xFF6C63FF),
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
