// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:chatapp/core/widgets/show_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FireStoreService {
  static String uploadedFilePath = "";

  static Future<void>  uploadFile( File file, String folderName)async{
    try {
      var snapshot = await FirebaseStorage.instance.ref().child("$folderName/${FirebaseAuth.instance.currentUser!.email}").putFile(file);

      uploadedFilePath = await snapshot.ref.getDownloadURL();
    } catch (e) {
      showMessageHelper(e.toString());
    }
  }
}
