// ignore_for_file: avoid_print, no_logic_in_create_state

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../../modelo/ActividadModelo.dart';
import 'package:geolocator/geolocator.dart';

class MyAppQR extends StatefulWidget {
  ActividadModelo modelA;
  MyAppQR({super.key, required this.modelA});

  @override
  MyAppState createState() => MyAppState(modelA: modelA);
}

class MyAppState extends State<MyAppQR> {
  ActividadModelo modelA;
  MyAppState({required this.modelA}) : super();
  String _scanBarcode = 'Unknown';
  Position? currentPosition;
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  @override
  void initState() {
    super.initState();
  }

  void registrarAsistencia() async {}

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) {
      _scanBarcode = barcode;
      print("Lecturado: $barcode");
      registrarAsistencia();
      /*if (!mounted) return;
      setState(() {
        _scanBarcode = barcode;
      });*/
    });
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      _scanBarcode = barcodeScanRes;
      registrarAsistencia();
    });
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
      registrarAsistencia();
    });
  }

  @override
  Widget build(BuildContext context) {
    getCurrentLocation();
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
                title: const Text('Registrar Asistencia'), centerTitle: true),
            body: Builder(builder: (BuildContext context) {
              return Container(
                  alignment: Alignment.center,
                  child: Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: () => scanBarcodeNormal(),
                            child: const Text('Start barcode scan')),
                        ElevatedButton(
                            onPressed: () => scanQR(),
                            child: const Text('Start QR scan')),
                        ElevatedButton(
                            onPressed: () => startBarcodeScanStream(),
                            child: const Text('Start barcode scan stream')),
                        Text('Scan result : $_scanBarcode\n',
                            style: const TextStyle(fontSize: 20))
                      ]));
            })));
  }

  Future<bool> permiso() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }
    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  Future<void> getCurrentLocation() async {
    final hasPermission = await permiso();
    if (!hasPermission) {
      return;
    }
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        currentPosition = position;
        //getCurrentLocationAddress();
      });
    }).catchError((e) {
      print(e);
    });
  }
}
