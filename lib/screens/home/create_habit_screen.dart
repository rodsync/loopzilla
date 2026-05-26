import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateHabitScreen extends StatefulWidget {
  const CreateHabitScreen({super.key});

  @override
  State<CreateHabitScreen> createState() =>
      _CreateHabitScreenState();
}

class _CreateHabitScreenState
    extends State<CreateHabitScreen> {

  final TextEditingController titleController =
  TextEditingController();

  String selectedRepeat = 'Daily';

  final List<String> repeatOptions = [
    'Daily',
    'Weekly',
    'Monthly',
  ];

  final List<String> emojis = [
    '🏀',
    '🎯',
    '🧘',
    '💪',
    '🎮',
    '📚',
  ];

  String selectedEmoji = '🏀';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          'Create New Habit',
          style: TextStyle(color: Colors.black),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            const Text(
              'Habit Name',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: titleController,

              decoration: InputDecoration(
                hintText: 'Habit Name',

                filled: true,
                fillColor: Colors.grey.shade100,

                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(14),

                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Select Emoji',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Wrap(
              spacing: 12,
              runSpacing: 12,

              children: emojis.map((emoji) {

                bool selected =
                    selectedEmoji == emoji;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedEmoji = emoji;
                    });
                  },

                  child: Container(
                    width: 60,
                    height: 60,

                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFF5E8748)
                          : Colors.grey.shade100,

                      borderRadius:
                      BorderRadius.circular(16),
                    ),

                    child: Center(
                      child: Text(
                        emoji,
                        style: const TextStyle(
                          fontSize: 28,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            const Text(
              'Repeat',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Container(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 16,
              ),

              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius:
                BorderRadius.circular(14),
              ),

              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedRepeat,
                  isExpanded: true,

                  items: repeatOptions.map((item) {

                    return DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),

                  onChanged: (value) {
                    setState(() {
                      selectedRepeat = value!;
                    });
                  },
                ),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
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

                onPressed: () async {

                  try {

                    if (titleController.text
                        .trim()
                        .isEmpty) {
                      return;
                    }

                    String uid =
                        FirebaseAuth
                            .instance
                            .currentUser!
                            .uid;

                    await FirebaseFirestore
                        .instance
                        .collection('users')
                        .doc(uid)
                        .collection('habits')
                        .add({

                      'title':
                      titleController.text.trim(),

                      'emoji': selectedEmoji,

                      'repeat': selectedRepeat,

                      'completed': false,

                      'color': 4294958757,

                      'createdAt':
                      Timestamp.now(),
                    });

                    if (!mounted) return;

                    Navigator.pop(context);

                  } catch (e) {

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      SnackBar(
                        content: Text(
                          e.toString(),
                        ),
                      ),
                    );
                  }
                },

                child: const Text(
                  'Save Habit',

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}