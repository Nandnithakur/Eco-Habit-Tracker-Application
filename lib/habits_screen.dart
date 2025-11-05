import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  final List<Map<String, dynamic>> habits = [
    {"name": "Use reusable water bottle", "done": true, "datetime": "2025-11-03 08:00 AM"},
    {"name": "Bike instead of car", "done": false, "datetime": "2025-11-04 07:30 AM"},
    {"name": "Recycle waste", "done": true, "datetime": "2025-11-02 06:45 PM"},
    {"name": "Plant a tree", "done": false, "datetime": "2025-11-05 09:00 AM"},
    {"name": "Turn off unused lights", "done": false, "datetime": "2025-11-06 10:15 PM"},
  ];

  String _selectedGoal = "Moderate";
  final ScrollController _scrollController = ScrollController();

  // 🌿 Enhanced Modal Bottom Sheet – Add Habit
  void _showAddHabitModal() {
    TextEditingController controller = TextEditingController();
    DateTime? selectedDateTime;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            String formattedDateTime = selectedDateTime != null
                ? DateFormat('dd MMM yyyy, hh:mm a').format(selectedDateTime!)
                : "No date/time selected";

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                left: 16,
                right: 16,
                top: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "🪴 Add New Habit",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    // 🌱 Habit Name
                    TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: "Enter habit name",
                        prefixIcon: const Icon(Icons.eco_outlined, color: Colors.green),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 📅 Date & Time Picker
                    ElevatedButton.icon(
                      onPressed: () async {
                        final now = DateTime.now();
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: now,
                          firstDate: DateTime(now.year - 1),
                          lastDate: DateTime(now.year + 2),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Colors.green,
                                  onPrimary: Colors.white,
                                  onSurface: Colors.black,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );

                        if (pickedDate != null) {
                          final pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: Colors.green,
                                    onPrimary: Colors.white,
                                    onSurface: Colors.black,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );

                          if (pickedTime != null) {
                            final combined = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                            setModalState(() {
                              selectedDateTime = combined;
                            });
                          }
                        }
                      },
                      icon: const Icon(Icons.calendar_today_outlined),
                      label: const Text("Pick Date & Time"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 🕒 Selected DateTime Preview
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time, color: Colors.green),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              formattedDateTime,
                              style: TextStyle(
                                color: selectedDateTime != null ? Colors.black87 : Colors.grey,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ✅ Add Habit Button
                    ElevatedButton.icon(
                      onPressed: () {
                        final habitName = controller.text.trim();
                        if (habitName.isEmpty || selectedDateTime == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("⚠️ Please enter habit name and pick date/time!"),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                          return;
                        }

                        setState(() {
                          habits.add({
                            "name": habitName,
                            "done": false,
                            "datetime": DateFormat('dd MMM yyyy, hh:mm a').format(selectedDateTime!),
                          });
                        });

                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "✅ Habit '$habitName' added for ${DateFormat('dd MMM yyyy, hh:mm a').format(selectedDateTime!)}",
                              style: const TextStyle(fontSize: 15),
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("Add Habit"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // 📊 Persistent Bottom Sheet – Habit Stats
  void _showHabitStatsPersistent() {
    showBottomSheet(
      context: context,
      backgroundColor: Colors.green.shade50,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final completed = habits.where((h) => h["done"]).length;
        final total = habits.length;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 200,
            child: Column(
              children: [
                const Text(
                  "Today's Habit Stats",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text("Completed $completed of $total habits 🌱",
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Close"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "🔥 Your Habits",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // ✅ Habit List
          ...habits.asMap().entries.map((entry) {
            int index = entry.key;
            var habit = entry.value;
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: CheckboxListTile(
                value: habit["done"],
                onChanged: (newValue) {
                  setState(() {
                    habits[index]["done"] = newValue!;
                  });
                },
                title: Text(
                  habit["name"],
                  style: TextStyle(
                    fontSize: 16,
                    decoration: habit["done"]
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: habit["done"] ? Colors.grey : Colors.black,
                  ),
                ),
                subtitle: Text(
                  "Date & Time: ${habit["datetime"]}",
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                activeColor: Colors.green,
              ),
            );
          }).toList(),

          const SizedBox(height: 24),
          const Text(
            "🎯 Your Daily Eco Goal",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // ✅ Goal Selection
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                RadioListTile<String>(
                  value: "Easy",
                  groupValue: _selectedGoal,
                  onChanged: (value) => setState(() => _selectedGoal = value!),
                  activeColor: Colors.green,
                  title: const Text("Easy (1–2 habits)"),
                ),
                RadioListTile<String>(
                  value: "Moderate",
                  groupValue: _selectedGoal,
                  onChanged: (value) => setState(() => _selectedGoal = value!),
                  activeColor: Colors.green,
                  title: const Text("Moderate (3–4 habits)"),
                ),
                RadioListTile<String>(
                  value: "Challenging",
                  groupValue: _selectedGoal,
                  onChanged: (value) => setState(() => _selectedGoal = value!),
                  activeColor: Colors.green,
                  title: const Text("Challenging (5+ habits)"),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ✅ Save Progress Button
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Progress saved! Goal: $_selectedGoal 🌱",
                    style: const TextStyle(fontSize: 16),
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            icon: const Icon(Icons.save),
            label: const Text("Save Progress"),
          ),

          const SizedBox(height: 12),

          // ✅ Persistent Bottom Sheet Button
          ElevatedButton.icon(
            onPressed: _showHabitStatsPersistent,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade400,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.bar_chart),
            label: const Text("View Habit Stats"),
          ),
        ],
      ),

      // ✅ Floating Action Button (Add Habit)
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green.shade700,
        onPressed: _showAddHabitModal,
        icon: const Icon(Icons.add),
        label: const Text("Add Habit"),
      ),
    );
  }
}
