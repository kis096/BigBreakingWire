import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  final Future<void> Function(bool) onThemeChanged;

  const SplashScreen({super.key, required this.onThemeChanged});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  // Delayed navigation to HomeScreen after splash
  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          toggleThemeMode: widget.onThemeChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor, // Adapt to theme
      body: Center(
        child: Image.asset(
          'assets/images/logo.png', // Ensure this path is correct
          width: 200,
          height: 200,
          fit: BoxFit.contain, // Ensure the image fits well
        ),
      ),
    );
  }
}
