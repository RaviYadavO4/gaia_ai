import 'package:flutter/material.dart';
import 'package:gaia_ai/screens/chat/chat_screen.dart';
import '../../models/chat_room.dart';
import '../../services/firestore_service.dart';

class ChatRoomListScreen extends StatelessWidget {
  final _service = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<ChatRoom>>(
        stream: _service.getChatRooms(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final rooms = snapshot.data!;
          if (rooms.isEmpty) {
            return Center(child: Text("No chat rooms yet."));
          }

          return ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              final room = rooms[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.blue[100],
                    child: Text(
                      room.name.isNotEmpty ? room.name[0].toUpperCase() : "?",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  title: Text(
                    room.name,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          roomId: room.id,
                          roomName: room.name,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final nameController = TextEditingController();
          await showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text("New Chat Room"),
              content: TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Room Name'),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    await _service.createChatRoom(nameController.text.trim());
                    Navigator.pop(context);
                  },
                  child: Text("Create"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
