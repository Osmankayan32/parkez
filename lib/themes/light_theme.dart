import 'package:flutter/material.dart';

class Themes {
  static Color primaryColor = const Color(0xFF1D5D9B);
  static Color secondaryColor = const Color(0xFF75C2F6);
  static Color accentColor = const Color(0xFFF4D160);
  static Color backgroundColor = const Color(0xFFFBEEAC);

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: backgroundColor,
    primaryColor: primaryColor,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

  );
}