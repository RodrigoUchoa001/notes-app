import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

final themeProvider = StateProvider<bool>((ref) => false);

final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    appBarTheme: AppBarTheme(
      foregroundColor: Colors.white,
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(
        color: Colors.black,
      ),
    ));

final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blueGrey,
    appBarTheme: AppBarTheme(
      foregroundColor: Colors.white,
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(
        color: Colors.black,
      ),
    ));
