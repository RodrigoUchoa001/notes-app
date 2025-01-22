import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// controls if the app is using light or dark mode themes.
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
  scaffoldBackgroundColor: Color(0xFF252525),
  brightness: Brightness.dark,
  primarySwatch: Colors.blueGrey,
  appBarTheme: AppBarTheme(
    foregroundColor: Colors.white,
  ),
  textTheme: TextTheme(
    bodyMedium: GoogleFonts.nunito(
      color: Colors.black,
    ),
  ),
);
