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
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. background image
          Image.asset(
            'assets/Splash_screen dp.png',
            fit: BoxFit.cover,
          ),

          // 2.dark overlay for readability
          Container(
            color: Colors.black.withOpacity(0.25),
          ),

          // 3.main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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

          // 4.Author credit (subtitle)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                'Developed by Nazmul Islam',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.55),
                  letterSpacing: 0.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
