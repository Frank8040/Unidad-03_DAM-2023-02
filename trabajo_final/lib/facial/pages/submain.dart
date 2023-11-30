import 'package:trabajo_final/facial/auth/sign_in.dart';
import 'package:trabajo_final/facial/auth/sign_up.dart';
import 'package:trabajo_final/facial/locator.dart';
import 'package:flutter/material.dart';
import 'package:trabajo_final/facial/services/face_detector_service.dart';
import 'package:trabajo_final/facial/services/ml_service.dart';

class SubMainPage extends StatefulWidget {
  const SubMainPage({super.key});

  @override
  State<SubMainPage> createState() => _SubMainPageState();
}

class _SubMainPageState extends State<SubMainPage> {
  bool _loading = false;

  final MLService _mlService = locator<MLService>();
  final FaceDetectorService _faceDetectorService =
      locator<FaceDetectorService>();

  @override
  void initState() {
    super.initState();
    _initializing();
  }

  _initializing() async {
    setState(() {
      _loading = true;
    });
    _faceDetectorService.initialize();
    await _mlService.initialize();

    setState(() {
      _loading = false;
    });
  }

  Widget _body() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 100.0, horizontal: 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const FaceCheckPage()));
            },
            icon: const Icon(
              Icons.camera_alt,
              size: 60.0,
            ),
          ),
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SignInPage()));
              },
              icon: const Icon(Icons.face, size: 60.0))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reconocimiento facial'),
      ),
      body:
          _loading ? const Center(child: CircularProgressIndicator()) : _body(),
    );
  }
}
