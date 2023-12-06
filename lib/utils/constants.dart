import 'package:flutter/material.dart';

double baseHeight = 640.0;

double screenAwareSize(double size, BuildContext context) {
  return size * MediaQuery.of(context).size.height / baseHeight;
}

const String SPLASH_PAGE = "SPLASH_PAGE";
const String MAIN_PAGE = 'MAIN_PAGE';
