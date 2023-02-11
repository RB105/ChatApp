import 'package:flutter/material.dart';

class DarkThemMode {
  static ThemeData theme = ThemeData(
    floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Colors.grey.shade800,foregroundColor:  const Color.fromARGB(255, 41, 40, 40),),
      listTileTheme: const ListTileThemeData(textColor: Colors.black,iconColor: Colors.black),
      scaffoldBackgroundColor: Colors.grey[350],
      appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueGrey,
          titleTextStyle: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0.0));
}
