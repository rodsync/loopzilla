import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../home/home_screen.dart';
import 'questions.dart';
import '../widgets/option_tile.dart';
import '../widgets/primary_button.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() =>
      _QuestionScreenState();
}

class _QuestionScreenState
    extends State<QuestionScreen> {

  int currentQuestion = 0;

  Map<String, dynamic> answers = {};

  void selectAnswer(String answer) {

    setState(() {
      answers[currentQuestion.toString()] =
          answer;
    });
  }

  Future<void> nextQuestion() async {

    if (currentQuestion <
        questions.length - 1) {

      setState(() {
        currentQuestion++;
      });

    } else {

      try {

        String uid =
            FirebaseAuth.instance.currentUser!.uid;

        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .update({
          'answers': answers,
          'onboardingDone': true,
        });

        if (!mounted) return;

        Navigator.pushReplacement(
          context,

          MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          ),
        );

      } catch (e) {

        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              'Error: $e',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    final question =
    questions[currentQuestion];

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              ClipRRect(
                borderRadius:
                BorderRadius.circular(20),

                child: LinearProgressIndicator(
                  value:
                  (currentQuestion + 1) /
                      questions.length,

                  minHeight: 10,

                  backgroundColor:
                  Colors.grey.shade200,

                  color:
                  const Color(0xFF5E8748),
                ),
              ),

              const SizedBox(height: 40),

              Text(
                question['question'],

                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 14),

              Text(
                question['subtitle'],

                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 40),

              Expanded(
                child: ListView.builder(
                  itemCount:
                  question['options'].length,

                  itemBuilder:
                      (context, index) {

                    final option =
                    question['options']
                    [index];

                    return OptionTile(
                      text: option,

                      isSelected:
                      answers[currentQuestion
                          .toString()] ==
                          option,

                      onTap: () {
                        selectAnswer(option);
                      },
                    );
                  },
                ),
              ),

              PrimaryButton(
                text: currentQuestion ==
                    questions.length - 1
                    ? 'Finish'
                    : 'Continue',

                onPressed:
                answers[currentQuestion
                    .toString()] ==
                    null
                    ? null
                    : nextQuestion,
              ),
            ],
          ),
        ),
      ),
    );
  }
}