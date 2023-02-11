import 'package:flutter/material.dart';

class LightThemMode {
  static ThemeData theme = ThemeData(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: Colors.white,foregroundColor:   Colors.grey),    
    listTileTheme: const ListTileThemeData(textColor: Colors.black),
    scaffoldBackgroundColor: const Color(0xffE5E5E5),
      appBarTheme:
          const AppBarTheme(
            backgroundColor: Colors.blue, 
            titleTextStyle: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
            iconTheme: IconThemeData(color: Colors.white),
            elevation: 0.0));
}
