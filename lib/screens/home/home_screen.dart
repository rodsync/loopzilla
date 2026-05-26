import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'create_habit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {

  bool showCompleted = false;

  @override
  Widget build(BuildContext context) {

    String uid =
        FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          'LoopZilla',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [

          IconButton(
            onPressed: () {},

            icon: const Icon(
              Icons.notifications_none,
              color: Colors.black,
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            const Text(
              'Today Tasks',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Keep going and complete your habits.',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 30),

            Row(
              children: [

                GestureDetector(
                  onTap: () {
                    setState(() {
                      showCompleted = false;
                    });
                  },

                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),

                    decoration: BoxDecoration(
                      color: !showCompleted
                          ? const Color(0xFF5E8748)
                          : Colors.grey.shade100,

                      borderRadius:
                      BorderRadius.circular(20),
                    ),

                    child: Text(
                      'All Tasks',

                      style: TextStyle(
                        color: !showCompleted
                            ? Colors.white
                            : Colors.black,

                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      showCompleted = true;
                    });
                  },

                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),

                    decoration: BoxDecoration(
                      color: showCompleted
                          ? const Color(0xFF5E8748)
                          : Colors.grey.shade100,

                      borderRadius:
                      BorderRadius.circular(20),
                    ),

                    child: Text(
                      'Completed',

                      style: TextStyle(
                        color: showCompleted
                            ? Colors.white
                            : Colors.black,

                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .collection('habits')
                    .snapshots(),

                builder: (context, snapshot) {

                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {

                    return const Center(
                      child:
                      CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData ||
                      snapshot.data!.docs.isEmpty) {

                    return const Center(
                      child: Text(
                        'No habits yet',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    );
                  }

                  final habits =
                  snapshot.data!.docs.where((doc) {

                    bool completed =
                        doc['completed'] ?? false;

                    return showCompleted
                        ? completed
                        : !completed;

                  }).toList();

                  if (habits.isEmpty) {

                    return Center(
                      child: Text(
                        showCompleted
                            ? 'No completed habits'
                            : 'No active habits',
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: habits.length,

                    itemBuilder:
                        (context, index) {

                      final habit =
                      habits[index];

                      return Container(
                        margin:
                        const EdgeInsets.only(
                          bottom: 16,
                        ),

                        padding:
                        const EdgeInsets.all(
                          18,
                        ),

                        decoration:
                        BoxDecoration(
                          color: Color(
                              habit['color']),
                          borderRadius:
                          BorderRadius.circular(
                              20),
                        ),

                        child: Row(
                          children: [

                            Container(
                              width: 52,
                              height: 52,

                              decoration:
                              BoxDecoration(
                                color:
                                Colors.white,

                                borderRadius:
                                BorderRadius
                                    .circular(
                                    16),
                              ),

                              child: Center(
                                child: Text(
                                  habit['emoji'],

                                  style:
                                  const TextStyle(
                                    fontSize: 28,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                                width: 16),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                                children: [

                                  Text(
                                    habit['title'],

                                    style:
                                    const TextStyle(
                                      fontSize:
                                      18,

                                      fontWeight:
                                      FontWeight
                                          .bold,
                                    ),
                                  ),

                                  const SizedBox(
                                      height: 6),

                                  Text(
                                    habit['completed']
                                        ? 'Completed'
                                        : 'In Progress',

                                    style:
                                    TextStyle(
                                      color: Colors
                                          .grey
                                          .shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            GestureDetector(
                              onTap: () async {

                                await FirebaseFirestore
                                    .instance
                                    .collection(
                                    'users')
                                    .doc(uid)
                                    .collection(
                                    'habits')
                                    .doc(habit.id)
                                    .update({
                                  'completed':
                                  !habit[
                                  'completed'],
                                });
                              },

                              child: CircleAvatar(
                                radius: 16,

                                backgroundColor:
                                habit['completed']
                                    ? Colors.green
                                    : Colors.white,

                                child: Icon(
                                  habit['completed']
                                      ? Icons.check
                                      : Icons
                                      .circle_outlined,

                                  color:
                                  habit['completed']
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton:
      FloatingActionButton(
        backgroundColor:
        const Color(0xFF5E8748),

        onPressed: () {

          Navigator.push(
            context,

            MaterialPageRoute(
              builder: (_) =>
              const CreateHabitScreen(),
            ),
          );
        },

        child: const Icon(Icons.add),
      ),

      bottomNavigationBar:
      BottomNavigationBar(
        currentIndex: 0,

        selectedItemColor:
        const Color(0xFF5E8748),

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}