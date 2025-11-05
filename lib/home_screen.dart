import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'progress_screen.dart';
import 'habits_screen.dart';
import 'settings_screen.dart';
import 'user_profile_screen.dart'; // ✅ Add this import for profile page

// 🌊 Curved ClipPath for header
class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

// 🌱 Custom Bottom Navigation Bar
class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {"icon": Icons.home, "label": "Home"},
      {"icon": Icons.show_chart, "label": "Progress"},
      {"icon": Icons.eco, "label": "Habits"},
      {"icon": Icons.settings, "label": "Settings"},
    ];

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = index == selectedIndex;

          return GestureDetector(
            onTap: () => onItemTapped(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: isSelected
                  ? BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(24),
              )
                  : null,
              child: Row(
                children: [
                  Icon(
                    item["icon"] as IconData,
                    color: isSelected ? Colors.green.shade700 : Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 250),
                    style: TextStyle(
                      color:
                      isSelected ? Colors.green.shade700 : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                    child: Text(item["label"] as String),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// 🌿 HomeScreen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    DashboardScreen(),
    ProgressScreen(),
    HabitsScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  // 🌱 Header Banner
  Widget _buildHeader(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = "Good Morning 🌞";
    } else if (hour < 17) {
      greeting = "Good Afternoon ☀️";
    } else {
      greeting = "Good Evening 🌙";
    }

    return Stack(
      children: [
        ClipPath(
          clipper: CurvedClipper(),
          child: Container(
            height: 210,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade800, Colors.green.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        Positioned(
          left: 16,
          top: 40,
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white,
                child: Icon(Icons.eco, color: Colors.green.shade700, size: 32),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(greeting,
                      style: const TextStyle(
                          fontSize: 16, color: Colors.white70)),
                  const Text("EcoHabit Tracker",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 4),
                  const Text("Stay green, stay healthy 🌱",
                      style: TextStyle(fontSize: 14, color: Colors.white70)),
                ],
              ),
            ],
          ),
        ),
        // 👤 Profile Icon (Clickable)
        Positioned(
          right: 16,
          top: 40,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UserProfileScreen()),
              );
            },
            child: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.green.shade700),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: CustomBottomNavigationBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}
