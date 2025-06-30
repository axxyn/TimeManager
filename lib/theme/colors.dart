import 'package:flutter/material.dart';


int channelToInt(double channel) {
  return (channel * 255.0).round() & 0xff;
}

MaterialColor getMaterialColor(Color color) {
  final int red = channelToInt(color.r);
  final int green = channelToInt(color.g);
  final int blue = channelToInt(color.b);

  final Map<int, Color> shades = {
    50: Color.fromRGBO(red, green, blue, .1),
    100: Color.fromRGBO(red, green, blue, .2),
    200: Color.fromRGBO(red, green, blue, .3),
    300: Color.fromRGBO(red, green, blue, .4),
    400: Color.fromRGBO(red, green, blue, .5),
    500: Color.fromRGBO(red, green, blue, .6),
    600: Color.fromRGBO(red, green, blue, .7),
    700: Color.fromRGBO(red, green, blue, .8),
    800: Color.fromRGBO(red, green, blue, .9),
    900: Color.fromRGBO(red, green, blue, 1),
  };

  return MaterialColor(color.toARGB32(), shades);
}

class AppColors {
  AppColors._();

  static const primary = Color(0xff9AFFA1);
  static const primaryDarker = Color(0xff38A92C);

  static const gray = Color(0xffF8F8F8);
  //static final gray = Color(0xffeeeeee);
  static const positive = Color(0xff21BA45);
  static const warning = Color(0xFFF2C037);
  static const negative = Color(0xffff4d4d);
  static const negativeDark = Color(0xffb33636);
  static const negativeDarker = Color(0xff330f0f);
}