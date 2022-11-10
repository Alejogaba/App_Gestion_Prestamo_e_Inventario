import 'package:flutter/material.dart';

class MiTema {
  tema() {
    return ThemeData(
      // Define the default brightness and colors.
      brightness: Brightness.light,
      bottomAppBarColor: Colors.green[900],
      backgroundColor: Colors.green[100],
      primaryColorLight: Colors.white,
      buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.normal,
          buttonColor: Colors.green[600],
          colorScheme: const ColorScheme.light()),

      // Define the default TextTheme. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.
      textTheme: const TextTheme(
        bodyText2: TextStyle(fontSize: 16.0),
      ),
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
          .copyWith(secondary: Colors.green[600]),
    );
  }

  light() {
    return ThemeData(
        brightness: Brightness.light,
        backgroundColor: Colors.green[100],
        primaryColor: Colors.green,
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.green[600]));
  }
}
