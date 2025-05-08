import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_room.dart';
import '../models/message.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 🔹 Get all chat rooms
  Stream<List<ChatRoom>> getChatRooms() {
    return _db.collection('chatRooms')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
        .map((doc) => ChatRoom.fromMap(doc.id, doc.data()))
        .toList());
  }

  // 🔹 Create a new chat room
  Future<void> createChatRoom(String name) async {
    await _db.collection('chatRooms').add({
      'name': name,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // 🔹 Send a message to a room
  Future<void> sendMessage(String roomId, Message message) async {
    await _db
      .collection('chatRooms')
      .doc(roomId)
      .collection('messages')
      .add(message.toMap());
  }

  // 🔹 Stream all messages in a room (ordered)
  Stream<List<Message>> getMessages(String roomId) {
    return _db
      .collection('chatRooms')
      .doc(roomId)
      .collection('messages')
      .orderBy('timestamp', descending: false)
      .snapshots()
      .map((snapshot) => snapshot.docs
        .map((doc) => Message.fromMap(doc.data()))
        .toList());
  }
}
