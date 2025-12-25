import 'dart:async';
import 'package:flutter/material.dart';
import 'splash_screen.dart'; // Import the SplashScreen

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _messageAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller for the fade effect
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Duration for showing the message
      vsync: this,
    );

    // Create the fade-in animation for the message
    _messageAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Start the animation
    _controller.forward();

    // Navigate to the SplashScreen after the message animation completes
    _navigateToSplashScreen();
  }

  void _navigateToSplashScreen() {
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              SplashScreen(), // Navigate to SplashScreen after message
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple, // Background color
      body: Center(
        child: FadeTransition(
          opacity: _messageAnimation,
          child: Text(
            'Hi there! I\'m Nazmul', // The initial message
            style: TextStyle(
              fontSize: 32,
              color: Colors.white10.withOpacity(0.8),
              fontWeight: FontWeight.bold,
              fontFamily: 'EmilysCandy-Regular', 
            ),
          ),
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
