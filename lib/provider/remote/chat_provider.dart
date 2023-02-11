import 'package:chatapp/data/remote/chat_app_service.dart';
import 'package:chatapp/data/remote/firestorage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  // CONTROLLERS
  TextEditingController messageController = TextEditingController();
  TextEditingController editingController = TextEditingController();

  final Stream<QuerySnapshot> chatStream = FirebaseFirestore.instance
      .collection("message")
      .orderBy('created_at')
      .snapshots();

  Future<void> writemessage() async {
    await ChatService.writemessage(messages: messageController.text);
  }

  void clearMessage({required TextEditingController controller}) {
    messageController.clear();
  }

  void arrowDown({required ScrollController scrollController}) {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 400), curve: Curves.bounceInOut);
  }

  Future<void> writeFileMessage() async {
    await ChatService.writemessage(messages: FireStoreService.uploadedFilePath);
  }

  Future<void> deleteMessage({required String id}) async {
    await ChatService.removeData(id);
  }

  Future<void> editMessage({
    required String id,
  }) async {
    await ChatService.updateData(id: id, message: editingController.text);
  }

  int currentIndex = 0;
  void changeLang() {
    if (currentIndex == 2) {
      currentIndex = 0;
      notifyListeners();
    } else {
      currentIndex++;
      notifyListeners();
    }
  }

  List<String> langs = ["en", "ru", "uz"];
}
