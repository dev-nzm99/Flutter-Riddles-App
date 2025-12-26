import 'dart:async';
import 'package:flashcards_quiz/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconAnimation;
  late Animation<double> _titleFadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _iconAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _titleFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
    _navigateToLoginPage();
  }

  void _navigateToLoginPage() {
    // Keep enough time for: logo fade + title fade + typing animation
    Timer(const Duration(seconds: 10), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FadeTransition(
              opacity: _iconAnimation,
              child: Lottie.asset(
                'assets/Puzzle (3).json',
                width: 150,
                height: 150,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(height: 20),

            // 1) Show "Riddly" first (fade in)
            FadeTransition(
              opacity: _titleFadeAnimation,
              child: Column(
                children: [
                  Text(
                    'Riddly',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 34,
                      color: Colors.white.withOpacity(0.85),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'EmilysCandy-Regular',
                    ),
                  ),

                  const SizedBox(height: 8),

                  // 2) Then show "Think . Guess . Win" in animated form
                  AnimatedTextKit(
                    isRepeatingAnimation: false,
                    totalRepeatCount: 1,
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Think . Guess . Win',
                        speed: const Duration(milliseconds: 90),
                        textStyle: TextStyle(
                          fontSize: 22,
                          color: Colors.white.withOpacity(0.70),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'EmilysCandy-Regular',
                        ),
                      ),
                    ],
                  ),
                ],
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
