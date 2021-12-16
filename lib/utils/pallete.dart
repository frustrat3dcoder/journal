import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor kToDark = MaterialColor(
    0xFF48879C, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xFFC6D8E0), //10%
      100: Color(0xFFC6D8E0), //20%
      200: Color(0xFFC6D8E0), //30%
      300: Color(0xFFC6D8E0), //40%
      400: Color(0xFFC6D8E0), //50%
      500: Color(0xFF48879C), //60%
      600: Color(0xFF48879C), //70%
      700: Color(0xFF48879C), //80%
      800: Color(0xFF48879C), //90%
      900: Color(0xFF48879C), //100%
    },
  );
}
