import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';

import 'create_habit_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  /// 0 = All Tasks
  /// 1 = Calendar
  /// 2 = Completed
  int selectedTab = 0;

  /// TIME FILTER
  String selectedTimeFilter = 'All';

  DateTime today = DateTime.now();
  DateTime focusedDay = DateTime.now();

  /// TIME FILTER FUNCTION
  bool matchesTimeFilter(String time) {

    if (selectedTimeFilter == 'All') {
      return true;
    }

    final hour =
    int.parse(time.split(':')[0]);

    if (selectedTimeFilter == 'Morning') {
      return hour >= 5 && hour < 12;
    }

    if (selectedTimeFilter == 'Afternoon') {
      return hour >= 12 && hour < 18;
    }

    if (selectedTimeFilter == 'Evening') {
      return hour >= 18 || hour < 5;
    }

    return true;
  }

  /// TIME FILTER BUTTON
  Widget buildTimeFilter(String label) {

    final selected =
        selectedTimeFilter == label;

    return Padding(
      padding: const EdgeInsets.only(right: 10),

      child: GestureDetector(

        onTap: () {
          setState(() {
            selectedTimeFilter = label;
          });
        },

        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),

          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFF5E8748)
                : Colors.white,

            borderRadius:
            BorderRadius.circular(30),

            border: Border.all(
              color: Colors.grey.shade300,
            ),
          ),

          child: Text(
            label,

            style: TextStyle(
              color:
              selected
                  ? Colors.white
                  : Colors.black,

              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    String uid = FirebaseAuth.instance.currentUser!.uid;

    return WillPopScope(

      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },

      child: Scaffold(

        backgroundColor: Colors.white,

        floatingActionButtonLocation:
        FloatingActionButtonLocation.centerDocked,

        floatingActionButton: SizedBox(
          width: 56,
          height: 56,

          child: FloatingActionButton(
            backgroundColor: const Color(0xFF5E8748),
            elevation: 0,

            onPressed: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CreateHabitScreen(),
                ),
              );
            },

            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 34,
              weight: 300,
            ),
          ),
        ),

        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 6,
          elevation: 0,
          color: Colors.white,

          child: SizedBox(
            height: 72,

            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceEvenly,

              children: [

                /// HOME
                Padding(
                  padding: const EdgeInsets.only(right: 18),

                  child: IconButton(
                    onPressed: () {},

                    icon: const Icon(
                      Icons.home_outlined,
                      color: Colors.grey,
                      size: 30,
                    ),
                  ),
                ),

                const SizedBox(width: 42),

                /// PROFILE
                Padding(
                  padding: const EdgeInsets.only(left: 18),

                  child: IconButton(
                    onPressed: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const ProfileScreen(),
                        ),
                      );
                    },

                    icon: const Icon(
                      Icons.person_outline,
                      color: Colors.grey,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        body: SafeArea(

          child: Padding(
            padding: const EdgeInsets.all(24),

            child: SingleChildScrollView(

              child: Column(
                children: [

                  /// TOP BAR
                  Row(
                    children: [

                      Image.asset(
                        'assets/logo.png',
                        width: 42,
                        height: 42,
                      ),

                      const Spacer(),

                      const Text(
                        'Home',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Spacer(),

                    ],
                  ),

                  const SizedBox(height: 30),

                  /// NAVIGATION
                  Container(
                    padding: const EdgeInsets.all(4),

                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius:
                      BorderRadius.circular(30),
                    ),

                    child: Row(
                      children: [

                        /// ALL TASKS
                        Expanded(
                          child: GestureDetector(

                            onTap: () {
                              setState(() {
                                selectedTab = 0;
                              });
                            },

                            child: Container(
                              padding:
                              const EdgeInsets.symmetric(
                                vertical: 12,
                              ),

                              decoration: BoxDecoration(
                                color: selectedTab == 0
                                    ? const Color(
                                  0xFF5E8748,
                                )
                                    : Colors.transparent,

                                borderRadius:
                                BorderRadius.circular(30),
                              ),

                              child: Text(
                                'All tasks',
                                textAlign: TextAlign.center,

                                style: TextStyle(
                                  color: selectedTab == 0
                                      ? Colors.white
                                      : Colors.black,

                                  fontWeight:
                                  FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),

                        /// CALENDAR
                        Expanded(
                          child: GestureDetector(

                            onTap: () {
                              setState(() {
                                selectedTab = 1;
                              });
                            },

                            child: Container(
                              padding:
                              const EdgeInsets.symmetric(
                                vertical: 12,
                              ),

                              decoration: BoxDecoration(
                                color: selectedTab == 1
                                    ? const Color(
                                  0xFF5E8748,
                                )
                                    : Colors.transparent,

                                borderRadius:
                                BorderRadius.circular(30),
                              ),

                              child: Text(
                                'Calendar',
                                textAlign: TextAlign.center,

                                style: TextStyle(
                                  color: selectedTab == 1
                                      ? Colors.white
                                      : Colors.black,

                                  fontWeight:
                                  FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),

                        /// COMPLETED
                        Expanded(
                          child: GestureDetector(

                            onTap: () {
                              setState(() {
                                selectedTab = 2;
                              });
                            },

                            child: Container(
                              padding:
                              const EdgeInsets.symmetric(
                                vertical: 12,
                              ),

                              decoration: BoxDecoration(
                                color: selectedTab == 2
                                    ? const Color(
                                  0xFF5E8748,
                                )
                                    : Colors.transparent,

                                borderRadius:
                                BorderRadius.circular(30),
                              ),

                              child: Text(
                                'Completed',
                                textAlign: TextAlign.center,

                                style: TextStyle(
                                  color: selectedTab == 2
                                      ? Colors.white
                                      : Colors.black,

                                  fontWeight:
                                  FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// TIME FILTER
                  if (selectedTab == 0) ...[

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,

                      child: Row(
                        children: [

                          buildTimeFilter('All'),

                          buildTimeFilter('Morning'),

                          buildTimeFilter('Afternoon'),

                          buildTimeFilter('Evening'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],

                  /// CALENDAR TAB
                  if (selectedTab == 1)

                    SizedBox(
                      height:
                      MediaQuery.of(context).size.height * 0.7,

                      child: StreamBuilder<QuerySnapshot>(

                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .collection('habits')
                            .snapshots(),

                        builder: (context, snapshot) {

                          if (!snapshot.hasData) {

                            return const Center(
                              child:
                              CircularProgressIndicator(),
                            );
                          }

                          Map<DateTime,
                              List<Map<String, dynamic>>>
                          events = {};

                          for (var doc
                          in snapshot.data!.docs) {

                            final data =
                            doc.data()
                            as Map<String, dynamic>;

                            if (data.containsKey('date') &&
                                data['date'] != null) {

                              DateTime date =
                              (data['date']
                              as Timestamp)
                                  .toDate();

                              final cleanDate = DateTime(
                                date.year,
                                date.month,
                                date.day,
                              );

                              if (events[cleanDate] ==
                                  null) {
                                events[cleanDate] = [];
                              }

                              events[cleanDate]!
                                  .add(data);
                            }
                          }

                          final selectedHabits =
                          snapshot.data!.docs.where(
                                (doc) {

                              final data =
                              doc.data()
                              as Map<String,
                                  dynamic>;

                              if (!data.containsKey(
                                  'date')) {
                                return false;
                              }

                              DateTime date =
                              (data['date']
                              as Timestamp)
                                  .toDate();

                              return isSameDay(
                                today,
                                date,
                              );
                            },
                          ).toList();

                          return Column(
                            children: [

                              /// CALENDAR
                              Container(
                                padding:
                                const EdgeInsets.all(12),

                                decoration: BoxDecoration(
                                  color: Colors.white,

                                  borderRadius:
                                  BorderRadius.circular(
                                    20,
                                  ),

                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withOpacity(
                                        0.05,
                                      ),

                                      blurRadius: 10,
                                    ),
                                  ],
                                ),

                                child: TableCalendar(

                                  firstDay:
                                  DateTime.utc(
                                    2020,
                                    1,
                                    1,
                                  ),

                                  lastDay:
                                  DateTime.utc(
                                    2100,
                                    12,
                                    31,
                                  ),

                                  focusedDay:
                                  focusedDay,

                                  selectedDayPredicate:
                                      (day) {

                                    return isSameDay(
                                      today,
                                      day,
                                    );
                                  },

                                  onDaySelected:
                                      (
                                      selectedDay,
                                      focusedDay,
                                      ) {

                                    setState(() {

                                      today =
                                          selectedDay;

                                      this.focusedDay =
                                          focusedDay;
                                    });
                                  },

                                  eventLoader: (day) {

                                    return events[
                                    DateTime(
                                      day.year,
                                      day.month,
                                      day.day,
                                    )
                                    ] ??
                                        [];
                                  },

                                  headerStyle:
                                  const HeaderStyle(
                                    formatButtonVisible:
                                    false,

                                    titleCentered:
                                    true,
                                  ),

                                  calendarStyle:
                                  CalendarStyle(

                                    todayDecoration:
                                    const BoxDecoration(
                                      color: Color(
                                        0xFF5E8748,
                                      ),

                                      shape:
                                      BoxShape.circle,
                                    ),

                                    selectedDecoration:
                                    const BoxDecoration(
                                      color: Color(
                                        0xFFF5B24F,
                                      ),

                                      shape:
                                      BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              /// HABITS OF SELECTED DATE
                              Expanded(
                                child:
                                selectedHabits.isEmpty

                                    ? const Center(
                                  child: Text(
                                    'No habits on this date',
                                  ),
                                )

                                    : ListView.builder(

                                  itemCount:
                                  selectedHabits.length,

                                  itemBuilder:
                                      (
                                      context,
                                      index,
                                      ) {

                                    final habit =
                                    selectedHabits[
                                    index];

                                    return Container(

                                      margin:
                                      const EdgeInsets.only(
                                        bottom: 14,
                                      ),

                                      padding:
                                      const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 14,
                                      ),

                                      decoration:
                                      BoxDecoration(
                                        color: Color(
                                          habit['color'],
                                        ),

                                        borderRadius:
                                        BorderRadius.circular(
                                          14,
                                        ),
                                      ),

                                      child: Row(
                                        children: [

                                          Text(
                                            habit['emoji'],
                                            style:
                                            const TextStyle(
                                              fontSize: 24,
                                            ),
                                          ),

                                          const SizedBox(
                                            width: 14,
                                          ),

                                          Expanded(
                                            child: Text(
                                              habit['title'],
                                              style:
                                              const TextStyle(
                                                fontSize: 16,

                                                fontWeight:
                                                FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                  /// ALL TASKS + COMPLETED
                  if (selectedTab != 1)

                    SizedBox(
                      height:
                      MediaQuery.of(context).size.height * 0.7,

                      child:
                      StreamBuilder<QuerySnapshot>(

                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .collection('habits')
                            .snapshots(),

                        builder: (context, snapshot) {

                          if (!snapshot.hasData) {

                            return const Center(
                              child:
                              CircularProgressIndicator(),
                            );
                          }

                          List habits = snapshot.data!.docs.where((doc) {

                            final data =
                            doc.data() as Map<String, dynamic>;

                            bool completed =
                                data['completed'] ?? false;

                            String time =
                                data['time'] ?? '00:00';

                            int hour =
                            int.parse(time.split(':')[0]);

                            /// ALL TASKS
                            if (selectedTab == 0) {

                              if (completed) return false;

                              /// ALL
                              if (selectedTimeFilter == 'All') {
                                return true;
                              }

                              /// MORNING
                              if (selectedTimeFilter == 'Morning') {
                                return hour >= 5 && hour < 12;
                              }

                              /// AFTERNOON
                              if (selectedTimeFilter == 'Afternoon') {
                                return hour >= 12 && hour < 18;
                              }

                              /// EVENING
                              if (selectedTimeFilter == 'Evening') {
                                return hour >= 18 || hour < 5;
                              }
                            }

                            /// COMPLETED TAB
                            return completed;

                          }).toList();

                          if (habits.isEmpty) {

                            return Center(
                              child: Text(
                                selectedTab == 0
                                    ? 'No active habits'
                                    : 'No completed habits',
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
                                  bottom: 14,
                                ),

                                padding:
                                const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),

                                decoration:
                                BoxDecoration(
                                  color: Color(
                                    habit['color'],
                                  ),

                                  borderRadius:
                                  BorderRadius.circular(
                                    14,
                                  ),
                                ),

                                child: Row(
                                  children: [

                                    Text(
                                      habit['emoji'],

                                      style:
                                      const TextStyle(
                                        fontSize: 24,
                                      ),
                                    ),

                                    const SizedBox(
                                      width: 14,
                                    ),

                                    Expanded(
                                      child: Text(
                                        habit['title'],

                                        style:
                                        const TextStyle(
                                          fontSize: 16,

                                          fontWeight:
                                          FontWeight.w600,
                                        ),
                                      ),
                                    ),

                                    /// EDIT BUTTON (ONLY FOR ACTIVE TASKS)
                                    if (selectedTab == 0)
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit_outlined,
                                          color: Colors.black54,
                                        ),

                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => CreateHabitScreen(
                                                habit: habit,
                                              ),
                                            ),
                                          );
                                        },
                                      ),

                                    /// DELETE BUTTON
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                      ),

                                      onPressed: () async {

                                        bool? confirmDelete = await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text('Delete Habit'),
                                              content: const Text(
                                                'Are you sure you want to delete this habit?',
                                              ),
                                              actions: [

                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context, false);
                                                  },
                                                  child: const Text('Cancel'),
                                                ),

                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context, true);
                                                  },
                                                  child: const Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );

                                        if (confirmDelete == true) {

                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(uid)
                                              .collection('habits')
                                              .doc(habit.id)
                                              .delete();

                                          if (!mounted) return;

                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Habit deleted'),
                                            ),
                                          );
                                        }
                                      },
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

                                      child:
                                      CircleAvatar(
                                        radius: 14,

                                        backgroundColor:
                                        Colors.green,

                                        child: Icon(
                                          habit[
                                          'completed']
                                              ? Icons.check
                                              : Icons.circle,

                                          color:
                                          Colors.white,

                                          size: 18,
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
          ),
        ),
      ),
    );
  }
}