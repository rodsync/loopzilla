import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateHabitScreen extends StatefulWidget {
  final DocumentSnapshot? habit;

  const CreateHabitScreen({
    super.key,
    this.habit,
  });

  @override
  State<CreateHabitScreen> createState() =>
      _CreateHabitScreenState();
}

class _CreateHabitScreenState extends State<CreateHabitScreen> {
  final TextEditingController titleController = TextEditingController();

  String selectedRepeat = 'Daily';

  final List<String> repeatOptions = [
    'Daily',
    'Weekly',
    'Monthly',
  ];

  final List<String> emojis = [
    '🏈','🏆','🏅','🏀','🎵',
    '📚','💪','🧘','🚴','🏃',
    '🍎','💧','😴','🎮','✍️',
  ];

  final List<Color> colors = [
    const Color(0xFFEFEEC9),
    const Color(0xFFF5B24F),
    const Color(0xFFC8C1C1),
    const Color(0xFFB59A86),
    const Color(0xFFE85D75),
  ];

  final List<Map<String, String>> weekDays = [
    {'label': 'S', 'value': 'Sun'},
    {'label': 'M', 'value': 'Mon'},
    {'label': 'T', 'value': 'Tue'},
    {'label': 'W', 'value': 'Wed'},
    {'label': 'T', 'value': 'Thu'},
    {'label': 'F', 'value': 'Fri'},
    {'label': 'S', 'value': 'Sat'},
  ];

  String selectedEmoji = '🏈';
  Color selectedColor = const Color(0xFFEFEEC9);
  bool reminder = true;

  List<String> selectedDays = [];

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();

    if (widget.habit != null) {
      final data = widget.habit!.data() as Map<String, dynamic>;

      titleController.text = data['title'] ?? '';
      selectedEmoji = data['emoji'] ?? '🏈';
      selectedRepeat = data['repeat'] ?? 'Daily';
      selectedColor = Color(data['color'] ?? 0xFFEFEEC9);
      reminder = data['reminder'] ?? true;

      selectedDays = List<String>.from(data['selectedDays'] ?? []);

      if (data['date'] != null) {
        selectedDate = (data['date'] as Timestamp).toDate();
      }

      if (data['time'] != null) {
        final parts = data['time'].split(':');
        selectedTime = TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// TOP BAR
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      widget.habit == null
                          ? 'Create New Habit'
                          : 'Edit Habit',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                /// NAME
                const Text(
                  'Habit Name',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),

                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'Habit Name',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                /// ICONS
                const Text('Icon',
                    style: TextStyle(fontWeight: FontWeight.w600)),

                const SizedBox(height: 12),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: emojis.map((emoji) {
                    final selected = selectedEmoji == emoji;

                    return GestureDetector(
                      onTap: () =>
                          setState(() => selectedEmoji = emoji),
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selected
                                ? const Color(0xFF6E8E59)
                                : Colors.grey.shade300,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(emoji,
                              style: const TextStyle(fontSize: 24)),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 25),

                /// COLORS
                const Text('Color',
                    style: TextStyle(fontWeight: FontWeight.w600)),

                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: colors.map((color) {
                    final selected = selectedColor == color;

                    return GestureDetector(
                      onTap: () =>
                          setState(() => selectedColor = color),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                          border: selected
                              ? Border.all(color: Colors.black, width: 2)
                              : null,
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 25),

                /// REPEAT
                const Text('Repeat',
                    style: TextStyle(fontWeight: FontWeight.w600)),

                const SizedBox(height: 10),

                DropdownButton<String>(
                  value: selectedRepeat,
                  isExpanded: true,
                  items: repeatOptions
                      .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  ))
                      .toList(),
                  onChanged: (v) =>
                      setState(() => selectedRepeat = v!),
                ),

                const SizedBox(height: 20),

                /// WEEKLY SELECTOR (ONLY WHEN WEEKLY)
                if (selectedRepeat == 'Weekly') ...[
                  const Text('Repeat on',
                      style: TextStyle(fontWeight: FontWeight.w600)),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: weekDays.map((day) {
                      final selected =
                      selectedDays.contains(day['value']);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (selected) {
                              selectedDays.remove(day['value']);
                            } else {
                              selectedDays.add(day['value']!);
                            }
                          });
                        },
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFFF5B24F)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Center(
                            child: Text(
                              day['label']!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: selected
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                ],

                /// DATE + TIME
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() => selectedDate = picked);
                          }
                        },
                        child: _box(
                          Icons.calendar_today,
                          "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: selectedTime,
                          );
                          if (picked != null) {
                            setState(() => selectedTime = picked);
                          }
                        },
                        child: _box(
                          Icons.access_time,
                          selectedTime.format(context),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                /// BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFFF4F1D8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () async {
                      if (titleController.text.trim().isEmpty) return;

                      final ref = FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .collection('habits');

                      final data = {
                        'title': titleController.text.trim(),
                        'emoji': selectedEmoji,
                        'repeat': selectedRepeat,
                        'selectedDays': selectedDays,
                        'color': selectedColor.value,
                        'reminder': reminder,
                        'date': Timestamp.fromDate(selectedDate),
                        'time':
                        '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
                        'completed': widget.habit?.get('completed') ?? false,
                        'createdAt': widget.habit?['createdAt'] ?? Timestamp.now(),
                      };

                      if (widget.habit == null) {
                        await ref.add(data);
                      } else {
                        await ref.doc(widget.habit!.id).update(data);
                      }

                      if (!mounted) return;
                      Navigator.pop(context);
                    },
                    child: Text(
                      widget.habit == null ? 'Save Habit' : 'Update Habit',
                      style: const TextStyle(
                        color: Color(0xFF6E8E59),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _box(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}