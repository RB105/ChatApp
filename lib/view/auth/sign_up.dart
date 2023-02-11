import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/auth/sign_up_provider.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignUpProvider(),
      builder: (context, child) => _scaffold(context),
    );
  }

  Scaffold _scaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up").tr(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: TextFormField(
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              controller: context.watch<SignUpProvider>().emailController,
              decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: const TextStyle(fontWeight: FontWeight.bold),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 3),
                      borderRadius: BorderRadius.circular(20)),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 3),
                      borderRadius: BorderRadius.circular(20))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: TextFormField(
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              controller: context.watch<SignUpProvider>().passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  hintText: "Password".tr(),
                  hintStyle: const TextStyle(fontWeight: FontWeight.bold),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 3),
                      borderRadius: BorderRadius.circular(20)),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 3),
                      borderRadius: BorderRadius.circular(20))),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        children: [
          TextButton(
              onPressed: () {
                Navigator.pushNamed(context, 'in');
              },
              child: const Text("Sign in").tr()),
          FloatingActionButton.extended(
              onPressed: () async {
                await context.read<SignUpProvider>().signUp().then((value) {
                  if (value) {
                    Navigator.pushNamed(context, '/');
                  }
                });
              },
              label: const Text("Log in").tr()),
        ],
      ),
    );
  }
}
