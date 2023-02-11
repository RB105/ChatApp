import 'package:animate_do/animate_do.dart';
import 'package:chatapp/view/auth/sign_up.dart';
import 'package:chatapp/view/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3)).then((value) {
      checkUser();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeIn(
          delay: const Duration(milliseconds: 900),
          animate: true,
          duration: const Duration(milliseconds: 900),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GradientText("ChatApp",
                  style: const TextStyle(fontSize: 50,fontWeight: FontWeight.bold,fontFamily: 'Zeyada'),
                  gradientType: GradientType.radial,
                  gradientDirection: GradientDirection.ttb,
                  radius: 2.5,
                  colors: const [Colors.blue, Colors.red, Colors.teal]),
            ],
          ),
        ),
      ),
    );
  }

  void checkUser() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SignUpPage(),
            ));
      }
    });
  }
}
