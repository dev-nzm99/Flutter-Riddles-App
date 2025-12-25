import 'dart:async';
import 'package:flashcards_quiz/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Import Lottie for the animation

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller for the fade effect
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Fade-in animation for the icon
    _iconAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Fade-in animation for the title text
    _textAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Start the animation
    _controller.forward();

    // Navigate to LoginPage after the animation completes
    _navigateToLoginPage();
  }

  void _navigateToLoginPage() {
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              LoginPage(), // Navigate to LoginPage after the splash
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple, // Background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Lottie Animation for the splash screen logo
            FadeTransition(
              opacity: _iconAnimation,
              child: Lottie.asset(
                'assets/Puzzle (3).json', // Path to your JSON animation
                width: 150, // Width of the animation
                height: 150, // Height of the animation
                fit: BoxFit.fill, // Fit the animation inside the space
              ),
            ),
            SizedBox(height: 20),
            // Animated Text (fades in after the logo)
            FadeTransition(
              opacity: _textAnimation,
              child: Text(
                'Welcome to Flutter Riddles', // App title
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
