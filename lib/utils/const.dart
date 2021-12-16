import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF48879C);
const Color secondaryColor = Color(0xFFC6D8E0);
const MaterialColor kToDark = MaterialColor(
  0xFF48879C, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
  <int, Color>{
    50: Color(0xffc6d8e0), //10%
  },
);
