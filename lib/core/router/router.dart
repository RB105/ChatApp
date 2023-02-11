// ignore_for_file: body_might_complete_normally_nullable

import 'package:chatapp/view/auth/sign_in.dart';
import 'package:chatapp/view/auth/sign_up.dart';
import 'package:chatapp/view/pages/settings_page.dart';
import 'package:chatapp/view/screens/splash_screen.dart';
import 'package:flutter/material.dart';

import '../../view/pages/home_page.dart';


class RouteGenerator {
  static final RouteGenerator _generator = RouteGenerator._init();

  static RouteGenerator get router => _generator;

  RouteGenerator._init();

  Route? onGenerate(RouteSettings settings) {
    switch (settings.name) {
      case 'splash':
        return _navigate(const SplashScreen());
      case '/':
        return _navigate(const HomePage());
      case 'up':
        return _navigate(const SignUpPage());
      case 'in':
        return _navigate(const SignInPage());
       case 'settings':
        return _navigate(const SettingsPage());
    }
  }

  MaterialPageRoute _navigate(Widget page) {
    return MaterialPageRoute(
      builder: (context) => page,
    );
  }
}
