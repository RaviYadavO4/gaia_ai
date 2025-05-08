import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class VoiceBotProvider extends ChangeNotifier {
  final FlutterSoundRecorder recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer player = FlutterSoundPlayer();

  bool isRecording = false;
  bool isPlaying = false;
  bool _isRecorderReady = false;

  String? recordedPath;
  int recordedSeconds = 0;
  Timer? _timer;

  List<Map<String, String>> conversation = [];

  Future<void> init() async {
    await recorder.openRecorder();
    _isRecorderReady = true;
    await player.openPlayer();
  }

  Future<void> disposeBot() async {
    if (_isRecorderReady) {
      await recorder.closeRecorder();
      _isRecorderReady = false;
    }
    await player.closePlayer();
    _timer?.cancel();
  }

  Future<void> startRecording() async {
    if (!_isRecorderReady) return;

    final mic = await Permission.microphone.request();
    if (!mic.isGranted) return;

    final dir = await getTemporaryDirectory();
    recordedPath = '${dir.path}/vision_${DateTime.now().millisecondsSinceEpoch}.aac';

    await recorder.startRecorder(toFile: recordedPath!, codec: Codec.aacMP4);

    isRecording = true;
    recordedSeconds = 0;
    notifyListeners();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      recordedSeconds++;
      if (recordedSeconds >= 60) stopRecording();
      notifyListeners();
    });
  }

  Future<void> stopRecording() async {
    if (!_isRecorderReady) return;

    await recorder.stopRecorder();
    _timer?.cancel();

    isRecording = false;
    notifyListeners();

    await Future.delayed(Duration(seconds: 1));
    final aiText = "💡 That's a powerful vision. Let's make it real!";
    conversation.add({
      "user": "🎤 Voice Message (${recordedSeconds}s)",
      "ai": aiText,
    });
    notifyListeners();
  }

  Future<void> playRecording() async {
    if (recordedPath == null || isPlaying) return;

    await player.startPlayer(
      fromURI: recordedPath!,
      whenFinished: () {
        isPlaying = false;
        notifyListeners();
      },
    );

    isPlaying = true;
    notifyListeners();
  }

  Future<void> stopPlayback() async {
    await player.stopPlayer();
    isPlaying = false;
    notifyListeners();
  }

  Future<void> togglePlayback() async {
    isPlaying ? await stopPlayback() : await playRecording();
  }
}
