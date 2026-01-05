import 'package:flashcards_quiz/login_screen.dart';
import 'package:flashcards_quiz/views/home_screen.dart';
import 'package:flashcards_quiz/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://gmkbhresjgvooqckuuip.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imdta2JocmVzamd2b29xY2t1dWlwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjcwNTgwMjUsImV4cCI6MjA4MjYzNDAyNX0.WDhSdOR1zyIXnlGHtjO8leWBGjl8x8uC4dVgffRpQo8',
  );

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
      home: const SplashScreen(),
      routes: {
        // Define the route for HomePage after login or splash
        '/splash_screen': (context) => const SplashScreen(),
        '/home': (context) => const HomePage(
              username: '',
            ),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}
