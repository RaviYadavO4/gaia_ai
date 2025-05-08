import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String sender;
  final String uid;
  final String text;
  final DateTime timestamp;

  Message({
    required this.sender,
    required this.uid,
    required this.text,
    required this.timestamp,
  });

  factory Message.fromMap(Map<String, dynamic> data) {
    return Message(
      sender: data['sender'],
      uid: data['uid'],
      text: data['text'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
    'sender': sender,
    'uid': uid,
    'text': text,
    'timestamp': Timestamp.fromDate(timestamp),
  };
}
