import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flashcards_quiz/models/flutter_topics_model.dart';
import 'package:flashcards_quiz/views/flashcard_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Added for logout logic

class HomePage extends StatefulWidget {
  final String username;

  const HomePage({super.key, required this.username});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Track hover state for each grid item
  final Map<int, bool> _hoverStates = {};

  Future<void> _handleLogout(BuildContext context) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Log out"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Log out"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    // Supabase Logout Logic
    await Supabase.instance.client.auth.signOut();

    if (!context.mounted) return;

    // Return to login screen
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final Color cardBg = Colors.white.withOpacity(0.22);
    const Color bgColor3 = Color(0xFF673AB7);
    const Color appBarColor = Color(0xFF5E35B1);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          "Flutter Riddles",
          style: TextStyle(
            // Corrected here by wrapping properties in TextStyle
            fontSize: 21,
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontFamily: 'BerkshireSwash-Regular', // Added here
          ),
        ),
        actions: [
          IconButton(
            tooltip: "Logout",
            icon: const Icon(Icons.logout),
            onPressed: () => _handleLogout(context),
          ),
        ],
      ),

      backgroundColor: bgColor3,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Container(
                decoration: BoxDecoration(
                  color: bgColor3,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.21),
                      blurRadius: 20.0,
                      offset: const Offset(0.0, 10.0),
                      spreadRadius: -10,
                      blurStyle: BlurStyle.outer,
                    )
                  ],
                ),
                child: Image.asset("assets/dash.png"),
              ),
              const SizedBox(height: 10),
              Center(
                child: SizedBox(
                  height: 40,
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontFamily: 'VastShadow-Regular',
                    ),
                    child: Center(
                      child: AnimatedTextKit(
                        repeatForever: true,
                        isRepeatingAnimation: true,
                        pause: const Duration(milliseconds: 3000),
                        animatedTexts: [
                          TypewriterAnimatedText(
                            "Great to see you, ${widget.username.split(' ')[0]}!",
                            speed: const Duration(milliseconds: 100),
                            textAlign: TextAlign.center,
                          ),
                          TypewriterAnimatedText(
                            "Let’s begin the Riddles!",
                            speed: const Duration(milliseconds: 100),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.20,
                ),
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(), // ListView handles scrolling
                itemCount: flutterTopicsList.length,
                itemBuilder: (context, index) {
                  final topicsData = flutterTopicsList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewCard(
                            typeOfTopic: topicsData.topicQuestions,
                            topicName: topicsData.topicName,
                          ),
                        ),
                      );
                    },
                    child: MouseRegion(
                      onEnter: (_) {
                        setState(() {
                          _hoverStates[index] =
                              true; // Set hover state for the current item
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          _hoverStates[index] =
                              false; // Reset hover state for the current item
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color: _hoverStates[index] == true
                              ? const Color(0xFF7E57C2) //Colors.blue.shade300
                              : Colors.white70
                                  .withOpacity(0.25), // Hover color change
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: _hoverStates[index] == true
                                  ? Colors.black26
                                  : Colors.transparent,
                              blurRadius: _hoverStates[index] == true ? 8 : 4,
                              spreadRadius: _hoverStates[index] == true ? 4 : 2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                topicsData.topicIcon,
                                color: Colors.white,
                                size: 55,
                              ),
                              const SizedBox(height: 15),
                              Text(
                                topicsData.topicName,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                    ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
