import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/auth/sign_in_provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignInProvider(),
      builder: (context, child) => _scaffold(context),
    );
  }

  Scaffold _scaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign in").tr(),
        leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'up');
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: TextFormField(
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              controller: context.watch<SignInProvider>().emailController,
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
              controller: context.watch<SignInProvider>().passwordController,
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
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await context.read<SignInProvider>().signIn().then((value) {
              if (value) {
                Navigator.pushNamed(context, '/');
              }
            });
          },
          label: const Text("Sign in").tr()),
    );
  }
}
