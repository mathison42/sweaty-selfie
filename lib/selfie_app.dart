import 'package:flutter/material.dart';

class SelfieApp extends StatefulWidget {
  String path;

  SelfieApp(this.path);

  @override
  _SelfieAppState createState() => _SelfieAppState();
}

class _SelfieAppState extends State<SelfieApp> {

  @override
  Widget build(BuildContext context) {
    return Image.asset(widget.path);
  }
}