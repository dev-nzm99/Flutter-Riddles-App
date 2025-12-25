import 'package:flashcards_quiz/login_screen.dart';
import 'package:flashcards_quiz/views/home_screen.dart';
import 'package:flashcards_quiz/views/intro_screen.dart';
import 'package:flashcards_quiz/views/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Riddles',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      // Set IntroScreen as the first screen
      home: IntroScreen(),
      routes: {
        // Define the route for HomePage after login or splash
        '/splash_screen': (context) => SplashScreen(),
        '/home': (context) => const HomePage(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}
