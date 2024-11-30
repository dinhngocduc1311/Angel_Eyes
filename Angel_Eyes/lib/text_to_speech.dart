import 'package:flutter_tts/flutter_tts.dart';

FlutterTts flutterTts = FlutterTts();

Future<void> speak(String textToSpeak) async {
  await flutterTts.setLanguage("en-US");
  await flutterTts.setSpeechRate(0.5);
  await flutterTts.setVolume(1.0);
  await flutterTts.setPitch(1);
  try {
    var res = await flutterTts.speak(textToSpeak);
    if (res == 1) {
      print("Success");
    } else {
      print("Failure");
    }
  } catch (e) {
    print("Error: $e");
  }
}

