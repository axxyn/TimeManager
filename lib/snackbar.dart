import 'package:flutter/material.dart';

enum SnackBarColors {
  delete,
  add,
  update,
  error
}

extension Options on SnackBarColors {
  Color get color {
    return [Colors.red, Colors.green, Colors.blue, Colors.red][index];
  }

  String get desc {
    return ['Skasowano', 'Dodano', 'Zaaktualizowano', 'Error'][index];
  }
}

// TODO Overkill, maybe implement queue with descriptions and pull as many in one go over X seconds

class SnackBarController {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static void showSnackBar({SnackBarColors? snackBarColor, String? text, Color? color}) {
    assert(snackBarColor != null || (text != null && color != null));

    final color_ = snackBarColor != null ? snackBarColor.color : color!;
    final text_ = snackBarColor != null ? snackBarColor.desc : text!;
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        backgroundColor: color_,
        content: Text(text_),
      )
    );
  }
}