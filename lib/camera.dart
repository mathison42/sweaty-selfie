
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

class CameraApp extends StatefulWidget {
  List<CameraDescription> cameras;
  CameraApp(this.cameras);

  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {

  CameraController controller;
  bool backCamera = false;


  void initCamera() {
      controller = CameraController(widget.cameras[backCamera ? 0 : 1], ResolutionPreset.medium);
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
  }

  void flipCamera() {
    setState(() {
      backCamera = !backCamera;
      initCamera();
    });
  }

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();



  void takePicture() async {
    if (!controller.value.isInitialized) {
      print('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      print(e);
      return null;
    }
    print("File: $filePath");
    Navigator.pop(context, filePath);
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      body: GestureDetector (
        onDoubleTap: () {
          setState(() { flipCamera(); });
        },
        child: CameraPreview(controller),
      ),
      bottomNavigationBar: BottomAppBar(
        child: RaisedButton(
          onPressed: () {
            takePicture();
          },
          child: Text('Take Selfie!'),
        ),
      ),
    );
  }
}