
import 'package:chatapp/core/widgets/show_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  static CollectionReference messagesCollection =
      FirebaseFirestore.instance.collection('message');

  static FirebaseFirestore firebaseStorage = FirebaseFirestore.instance;

  static Future<bool> writemessage({required String messages}) async {
    try {
      await messagesCollection.add({
        'message': messages,
        'token': FirebaseAuth.instance.currentUser!.uid,
        'created_at': FieldValue.serverTimestamp(),
      });
      return true;
    } on FirebaseException catch (e) {
      showMessageHelper(e.message.toString());
      return false;
    }
  }

  static Future removeData(String id)async{
    await firebaseStorage.doc("messages/$id").delete();
  } 

  static Future updateData({required String id, required String message})async{
    await firebaseStorage.doc("messages/$id").set(
      {
        'message': message,
        'token': FirebaseAuth.instance.currentUser!.uid,
        'created_at': FieldValue.serverTimestamp(),
      }
    );
  } 
}
