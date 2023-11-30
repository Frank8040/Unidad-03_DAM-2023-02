// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:camera/camera.dart';
import 'package:trabajo_final/facial/locator.dart';
import 'package:flutter/material.dart';
import 'package:trabajo_final/facial/pages/dashboard.dart';
import 'package:trabajo_final/facial/services/camera_service.dart';
import 'package:trabajo_final/facial/services/face_detector_service.dart';
import 'package:trabajo_final/facial/services/ml_service.dart';
import 'package:trabajo_final/facial/utils/face_detector_painter.dart';
import 'package:trabajo_final/facial/widgets/camera_view.dart';

class FaceCheckPage extends StatefulWidget {
  const FaceCheckPage({super.key});

  @override
  State<FaceCheckPage> createState() => _FaceCheckPageState();
}

class _FaceCheckPageState extends State<FaceCheckPage> {
  bool _initializing = false;
  bool _isBusy = false;
  CustomPaint? _customPaint;

  String? _text;

  final FaceDetectorService _faceDetectorService =
      locator<FaceDetectorService>();

  final MLService _mlService = locator<MLService>();

  final CameraService _cameraService = locator<CameraService>();

  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _end();
    super.dispose();
  }

  _start() async {
    setState(() => _initializing = true);
    await _cameraService.initialize();
    setState(() => _initializing = false);
    _detectFace();
  }

  _end() {
    _cameraService.dispose();
  }

  _detectFace() {
    _cameraService.cameraController
        ?.startImageStream((CameraImage image) async {
      if (_cameraService.cameraController == null) return;
      if (_isBusy) return;
      _isBusy = true;

      await _cameraService.processImage(image);

      await _faceDetectorService.detectFace(_cameraService.inputImage!);

      if (_faceDetectorService.isFaceDetected) {
        final faces = _faceDetectorService.faces;
        final inputImage = _cameraService.inputImage;
        final painter = FaceDetectorPainter(
          faces,
          inputImage!.inputImageData!.size,
          inputImage.inputImageData!.imageRotation,
        );

        _customPaint = CustomPaint(painter: painter);
        await _mlService.predict(image, faces[0]);

        if (_mlService.person != null) {
          setState(() {
            _text = _mlService.person;
          });

          // Cancelar el temporizador anterior de manera segura
          _delayTimer?.cancel();
          _delayTimer = null;

          // Agregar un nuevo temporizador de 5 segundos antes de realizar la navegación
          _delayTimer = Timer(const Duration(seconds: 3), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const DashboardPage(),
              ),
            );
          });
        }
      } else {
        _customPaint = null;
        _text = null; // Limpiar el nombre si no se detecta la cara
        _delayTimer?.cancel(); // Cancelar el temporizador si no hay cara
      }

      if (mounted) {
        setState(() {});
      }
      _isBusy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _initializing
        ? const Center(child: CircularProgressIndicator())
        : CameraView(customPaint: _customPaint, text: _text);
  }
}
