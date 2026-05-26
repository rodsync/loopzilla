// walkthrough_screen.dart

import 'package:flutter/material.dart';

import '../auth/welcome_screen.dart';

class WalkthroughScreen extends StatefulWidget {
  const WalkthroughScreen({super.key});

  @override
  State<WalkthroughScreen> createState() => _WalkthroughScreenState();
}

class _WalkthroughScreenState extends State<WalkthroughScreen> {
  final PageController controller = PageController();

  int currentIndex = 0;

  final List<Map<String, String>> pages = [
    {
      "title":
      "Welcome to LoopZilla - Your Personal Habit Tracker",
      "desc":
      "Take control of your habits and transform your life with LoopZilla.",
    },
    {
      "title":
      "Explore LoopZilla Features for Your Journey",
      "desc":
      "Track habits and improve your productivity every day.",
    },
    {
      "title":
      "Unlock Your Potential with LoopZilla Now!",
      "desc":
      "Achieve your goals and stay motivated.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: controller,
                  itemCount: pages.length,

                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },

                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Container(
                          height: 250,
                          width: 250,

                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F2DD),
                            borderRadius:
                            BorderRadius.circular(30),
                          ),

                          child: Padding(
                            padding: const EdgeInsets.all(30),

                            child: Image.asset(
                              'assets/logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        const SizedBox(height: 50),

                        Text(
                          pages[index]['title']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          pages[index]['desc']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                            height: 1.5,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                      (index) {
                    return Container(
                      margin: const EdgeInsets.all(4),
                      width: currentIndex == index ? 24 : 8,
                      height: 8,

                      decoration: BoxDecoration(
                        color: currentIndex == index
                            ? const Color(0xFF5E8748)
                            : Colors.grey.shade300,

                        borderRadius:
                        BorderRadius.circular(20),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 40),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const WelcomeScreen(),
                          ),
                        );
                      },

                      style: OutlinedButton.styleFrom(
                        padding:
                        const EdgeInsets.symmetric(
                          vertical: 18,
                        ),

                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(20),
                        ),
                      ),

                      child: const Text("Skip"),
                    ),
                  ),

                  const SizedBox(width: 20),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (currentIndex ==
                            pages.length - 1) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const WelcomeScreen(),
                            ),
                          );
                        } else {
                          controller.nextPage(
                            duration:
                            const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        }
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color(0xFF5E8748),

                        padding:
                        const EdgeInsets.symmetric(
                          vertical: 18,
                        ),

                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(20),
                        ),
                      ),

                      child: Text(
                        currentIndex ==
                            pages.length - 1
                            ? "Let's Get Started"
                            : "Continue",

                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    )
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}