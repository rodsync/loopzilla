import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String selectedEmoji = '😊';

  final List<String> emojis = [
    '😊', '😎', '🔥', '🌟',
    '💪', '🚀', '🎯', '🧠',
    '🐱', '🐼', '👑', '❤️',
  ];

  @override
  void initState() {
    super.initState();
    loadEmoji();
  }

  Future<void> loadEmoji() async {
    String uid =
        FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot userDoc =
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    if (userDoc.exists) {
      final data =
      userDoc.data()
      as Map<String, dynamic>;

      setState(() {
        selectedEmoji = data['emoji'] ?? '😊';
      });
    }
  }

  void showEmojiPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),

      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: emojis.length,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () async {

                  String uid =
                      FirebaseAuth.instance.currentUser!.uid;

                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .update({
                    'emoji': emojis[index],
                  });

                  setState(() {
                    selectedEmoji = emojis[index];
                  });

                  Navigator.pop(context);
                },

                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius:
                    BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      emojis[index],
                      style: const TextStyle(
                        fontSize: 32,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void showLogoutDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(20),
          ),
          title: const Text(
            'Logout',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to logout?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();

                if (!context.mounted) return;

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                      (route) => false,
                );
              },
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String uid =
        FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get(),

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData ||
              !snapshot.data!.exists) {
            return const Center(
              child: Text('No user data'),
            );
          }

          final user =
          snapshot.data!.data()
          as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(24),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                const SizedBox(height: 10),

                /// PROFILE EMOJI
                Center(
                  child: GestureDetector(
                    onTap: showEmojiPicker,

                    child: Stack(
                      alignment:
                      Alignment.bottomRight,

                      children: [

                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF5E8748,
                            ).withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),

                          child: Center(
                            child: Text(
                              selectedEmoji,
                              style: const TextStyle(
                                fontSize: 52,
                              ),
                            ),
                          ),
                        ),

                        Container(
                          padding:
                          const EdgeInsets.all(8),
                          decoration:
                          const BoxDecoration(
                            color: Color(0xFF5E8748),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                const Text(
                  'Username',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius:
                    BorderRadius.circular(16),
                  ),
                  child: Text(
                    user['username'] ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Email',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius:
                    BorderRadius.circular(16),
                  ),
                  child: Text(
                    user['email'] ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding:
                      const EdgeInsets.symmetric(
                        vertical: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: showLogoutDialog,
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}