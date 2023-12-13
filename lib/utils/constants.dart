import 'package:flutter/material.dart';

double baseHeight = 640.0;

double screenAwareSize(double size, BuildContext context) {
  return size * MediaQuery.of(context).size.height / baseHeight;
}

const String LOGIN_PAGE = "LOGIN_PAGE";
const String SPLASH_PAGE = "SPLASH_PAGE";
const String MAIN_PAGE = 'MAIN_PAGE';
const String TOKEN = 'TOKEN';
