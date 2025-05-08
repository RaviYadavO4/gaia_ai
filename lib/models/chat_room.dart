class ChatRoom {
  final String id;
  final String name;

  ChatRoom({required this.id, required this.name});

  factory ChatRoom.fromMap(String id, Map<String, dynamic> data) {
    return ChatRoom(id: id, name: data['name']);
  }

  Map<String, dynamic> toMap() => {'name': name};
}
