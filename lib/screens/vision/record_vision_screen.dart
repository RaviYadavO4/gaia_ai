import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/vision/voice_bot_provider.dart';

class RecordVisionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bot = Provider.of<VoiceBotProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: bot.conversation.isEmpty
                ? Center(
                    child: Text(
                      bot.isRecording
                          ? "Recording..."
                          : "Press the mic to share your vision",
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  )
                : ListView.builder(
                    itemCount: bot.conversation.length,
                    padding: EdgeInsets.all(12),
                    itemBuilder: (context, index) {
                      final item = bot.conversation[index];
                      final isLast = index == bot.conversation.length - 1;

                      return Column(
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 2,
                            color: Colors.deepPurple.shade50,
                            child: ListTile(
                             
                              title: Text(item['user']!,style: TextStyle(color: Colors.black),),
                              trailing: isLast && !bot.isRecording
                                  ? IconButton(
                                      icon: Icon(
                                        bot.isPlaying
                                            ? Icons.pause_circle_filled
                                            : Icons.play_circle_fill,
                                        color: Colors.deepPurple,
                                        size: 32,
                                      ),
                                      onPressed: bot.togglePlayback,
                                    )
                                  : null,
                            ),
                          ),
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            color: Colors.grey.shade200,
                            child: ListTile(
                              leading: Icon(Icons.voice_chat,
                                  color: Colors.deepPurple),
                              title: Text(
                                item['ai']!,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black87),
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                        ],
                      );
                    },
                  ),
          ),

          if (bot.isRecording)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Text("Recording... ${bot.recordedSeconds}s",
                      style: TextStyle(fontSize: 16, color: Colors.red)),
                  SizedBox(height: 8),
                  LinearProgressIndicator(color: Colors.red),
                ],
              ),
            ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(bot.isRecording ? Icons.stop : Icons.mic),
                    label: Text(bot.isRecording ? "Stop Recording" : "Tap to Record"),
                    onPressed: bot.isRecording ? bot.stopRecording : bot.startRecording,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          bot.isRecording ? Colors.red : Colors.deepPurple,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
