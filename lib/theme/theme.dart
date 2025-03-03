import 'package:flutter/material.dart';

//light theme
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.grey.shade300,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    shape: CircleBorder(),
    backgroundColor: Colors.grey.shade300,
    foregroundColor: Colors.grey.shade900,
  ),
  colorScheme: ColorScheme.light(
    primary: Colors.grey.shade200,
    secondary: Colors.grey.shade400,
    inversePrimary: Colors.grey.shade800,
  ),
  textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.grey.shade900)),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.grey.shade200,
    contentTextStyle: TextStyle(color: Colors.grey.shade900),
    actionTextColor: Colors.grey.shade800,
  ),
);

//dark theme
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.grey.shade900,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    shape: CircleBorder(),
    backgroundColor: Colors.grey.shade700,
    foregroundColor: Colors.grey.shade300,
  ),
  colorScheme: ColorScheme.dark(
    primary: Colors.grey.shade800,
    secondary: Colors.grey.shade700,
    inversePrimary: Colors.grey.shade300,
  ),
  textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.grey.shade400)),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.grey.shade800,
    contentTextStyle: TextStyle(color: Colors.grey.shade300),
    actionTextColor: Colors.grey.shade300,
  ),
);
