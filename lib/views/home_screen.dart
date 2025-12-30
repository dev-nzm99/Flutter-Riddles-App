import 'package:flashcards_quiz/models/flutter_topics_model.dart';
import 'package:flashcards_quiz/views/flashcard_screen.dart';
import 'package:flutter/material.dart';
// If you use Firebase Auth, uncomment:
// import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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

    // ---- Logout logic (choose what matches your app) ----

    // 1) If you use Firebase Auth:
    // await FirebaseAuth.instance.signOut();

    // 2) If you store a token in SharedPreferences, clear it here.
    // (Example placeholder)
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.remove('token');

    // Then go to Login and remove all previous routes:
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);

    // If you prefer direct widget navigation instead of named route:
    // Navigator.of(context).pushAndRemoveUntil(
    //   MaterialPageRoute(builder: (_) => const LoginScreen()),
    //   (route) => false,
    // );
  }

  @override
  Widget build(BuildContext context) {
    final Color cardBg = Colors.white10.withOpacity(0.15);

    // Your main background
    const Color bgColor3 = Color(0xFF673AB7);

    // Slightly deeper purple for AppBar (works well on top of bgColor3)
    const Color appBarColor = Color(0xFF5E35B1);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hay"),
        backgroundColor: appBarColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: "Logout",
            iconSize: 24, // right size for AppBar
            constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            icon: const Icon(Icons.logout),
            onPressed: () => _handleLogout(context),
          ),
        ],
      ),
      backgroundColor: bgColor3,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 0, left: 15, right: 15),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Container(
                decoration: BoxDecoration(
                  color: bgColor3,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.24),
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
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Flutter ",
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  fontSize: 21,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                      ),
                      for (var i = 0; i < "Riddles!!!".length; i++) ...[
                        TextSpan(
                          text: "Riddles!!!"[i],
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                fontSize: 21 + i.toDouble(),
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                        ),
                      ]
                    ],
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
                physics: const BouncingScrollPhysics(),
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
                    child: Card(
                      color: cardBg,
                      elevation: 40,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
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
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
