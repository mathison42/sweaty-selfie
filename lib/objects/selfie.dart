import 'package:flutter/material.dart';

class Selfie {
  Selfie({
    this.owner,
    this.timestamp,
    this.path
  });

  final String owner;
  final DateTime timestamp;
  final String path;

  Widget getImage() {
    return Image.asset(path);
  }
}