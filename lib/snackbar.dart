import 'package:flutter/material.dart';

enum SnackBarColors {
  delete,
  add,
  update
}

extension GetColor on SnackBarColors {
  Color get color {
    return [Colors.red, Colors.green, Colors.blue][index];
  }

  String get desc {
    return ['Skasowano', 'Dodano', 'Zaaktualizowano'][index];
  }
}

// TODO Overkill, maybe implement queue with descriptions and pull as many in one go over X seconds

class SnackBarController {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static void showSnackBar(SnackBarColors snackBarColor) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        backgroundColor: snackBarColor.color,
        content: Text(snackBarColor.desc),
      )
    );
  }
}