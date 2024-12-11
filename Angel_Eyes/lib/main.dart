import 'package:flutter/material.dart';
import 'text_to_speech.dart';
import 'package:vibration/vibration.dart';
import 'package:angel_eyes/object_detector_view.dart';
import 'package:wakelock/wakelock.dart';
import 'initial.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Wakelock.enable();
  await appInit();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Angle Eyes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _vibrate();
    _speak();
    Future.delayed(const Duration(seconds: 8), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ObjectDetectorView()),
      );
    });
  }

  Future<void> _speak() async {
    await speak("Welcome to Angel Eyes - Vision for a Brighter Future. The main screen will appear right now...");
  }

  Future<void> _vibrate() async {
    bool? hasVibrator = await Vibration.hasVibrator();

    if (hasVibrator != null && hasVibrator) {
      Vibration.vibrate(duration: 3000);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const Positioned(
            top: 64,
            left: 8,
            right: 8,
            child: Center(
              child: Text(
                'Welcome to Angel Eyes - Vision for a Brighter Future.\nThe main screen will appear right now...',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Positioned(
            top: 250, // Adjust this value to move the logo higher or lower
            left: 8,
            right: 8,
            child: Center(
              child: Column(
                children: [
                  Image.asset('assets/logo.png', width: 150, height: 150),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Angel ',
                          style: TextStyle(
                            color: Color(0xFFB9B9B9),
                          ),
                        ),
                        TextSpan(
                          text: 'Eyes',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'Vision for a Brighter Future',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.black
                    ),
                  ),
                  Image.asset(
                    'assets/blind-man-cross.jpg',  // Replace with your second image path
                    width: 300,
                    height: 300),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}