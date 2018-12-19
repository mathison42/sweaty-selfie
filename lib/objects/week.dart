import 'package:flutter/material.dart';

class Week {
  final String title;
  final List<String> description;
  final int num;
  final List<Image> selfies;

  const Week({
    this.title,
    this.description,
    this.num,
    this.selfies
  });

}