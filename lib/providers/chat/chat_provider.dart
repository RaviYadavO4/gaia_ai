import 'package:flutter/material.dart';

import '../../models/message.dart';
import '../../services/firestore_service.dart';

class ChatProvider with ChangeNotifier {
  final FirestoreService _service = FirestoreService();

  Stream<List<Message>> messages(String roomId) => _service.getMessages(roomId);

  Future<void> sendMessage(String roomId, String text, String uid, String senderName) async {
  final msg = Message(
    sender: senderName,
    uid: uid,
    text: text,
    timestamp: DateTime.now(),
  );
  await _service.sendMessage(roomId, msg);
}

}
