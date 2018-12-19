import 'package:flutter/material.dart';

class Selfie {

  final String owner;
  final DateTime timestamp;
  final String path;
  
  Selfie({
    this.owner,
    this.timestamp,
    this.path
  });

  Widget getImage() {
    return Image.asset(path);
  }
}