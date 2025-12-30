import 'package:flashcards_quiz/widgets/dotted_lines.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Ensure this is imported

class ResultsCard extends StatelessWidget {
  const ResultsCard({
    super.key,
    required this.roundedPercentageScore,
    required this.bgColor3,
  });

  final int roundedPercentageScore;
  final Color bgColor3;

  // Added fetchUsername method directly inside the class
  Future<String> fetchUsername() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return "Guest";

    try {
      final data = await Supabase.instance.client
          .from('users')
          .select('username')
          .eq('email', user.email as Object)
          .maybeSingle();

      return data?['username'] ?? "User";
    } catch (e) {
      return "User";
    }
  }
  @override
  Widget build(BuildContext context) {
    const Color bgColor3 = Color(0xFF9575CD);
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.888,
      height: MediaQuery.of(context).size.height * 0.568,
      child: Stack(
        children: [
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      // Wrap RichText with FutureBuilder to handle the async username
                      child: FutureBuilder<String>(
                        future: fetchUsername(),
                        builder: (context, snapshot) {
                          String name = snapshot.data ?? "...";

                          return RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                for (var ii = 0;
                                    ii < "Congratulations!".length;
                                    ii++) ...[
                                  TextSpan(
                                    text: "Congratulations!"[ii],
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontSize: 13 + ii.toDouble(),
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF673AB7),
                                        ),
                                  ),
                                ],
                                // Displaying the fetched Username
                                TextSpan(
                                  text: " ${name.split(' ')[0]}\n",
                                  style: const TextStyle(
                                    fontFamily: 'VastShadow-Regular',
                                    fontSize: 22,
                                    color: Color(0xFF673AB7),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: "You Scored \n",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                TextSpan(
                                  text: "$roundedPercentageScore%",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  CustomPaint(
                    painter: DrawDottedhorizontalline(),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: roundedPercentageScore >= 75
                            ? Column(
                                children: [
                                  Text(
                                    "You have Earned this Trophy",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                  Image.asset("assets/bouncy-cup.gif",
                                      fit: BoxFit.fill,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.25),
                                ],
                              )
                            : Column(
                                children: [
                                  Text(
                                    "I know You can do better!!",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  Image.asset("assets/sad.png",
                                      fit: BoxFit.fill,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.25),
                                ],
                              ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          // Side Cut-out circles
          Positioned(
            left: -10,
            top: MediaQuery.of(context).size.height * 0.178,
            child: Container(
              height: 25,
              width: 25,
              decoration:
                  const BoxDecoration(color: bgColor3, shape: BoxShape.circle),
            ),
          ),
          Positioned(
            right: -10,
            top: MediaQuery.of(context).size.height * 0.178,
            child: Container(
              height: 25,
              width: 25,
              decoration:
                  const BoxDecoration(color: bgColor3, shape: BoxShape.circle),
            ),
          ),
        ],
      ),
    );
  }
}
