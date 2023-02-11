import 'package:chatapp/core/widgets/show_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInProvider extends ChangeNotifier {
  // Controller
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //Variables
  bool isLoading = false;

  // To sign up . . .
  Future<bool> signIn() async {
    try {
      isLoading = true;
    notifyListeners();
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text, password: passwordController.text);
      isLoading =false;
      notifyListeners();
        return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showMessageHelper("User not found");
        isLoading= false;
        notifyListeners();
      }else if(e.code == 'wrong-password'){
        showMessageHelper("wrong-password");
        isLoading= false;
        notifyListeners();
      }
       else {
        showMessageHelper("Something went wrong");
        isLoading= false;
        notifyListeners();
      }
      return false;
    }
  }
}
