import 'package:flutter/material.dart';

class MyThemes {
  static final darkTheme = ThemeData(
scaffoldBackgroundColor: Colors.grey.shade900,
   colorScheme: ColorScheme.dark(), // for text
    primarySwatch: Colors.teal,


    visualDensity: VisualDensity.adaptivePlatformDensity,

  );
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(),


    primarySwatch:Colors.teal,


    visualDensity: VisualDensity.adaptivePlatformDensity,


  );

}