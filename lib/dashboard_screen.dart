import 'package:flutter/material.dart';
import 'dart:math';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<String> _ecoQuotes = [
    "“The Earth is what we all have in common.” 🌍",
    "“Every small action counts towards a greener planet.” 🌱",
    "“Save water today for a better tomorrow.” 💧",
    "“Act as if what you do makes a difference. It does.” ♻️",
    "“Be the change you wish to see in the world.” 🌿",
  ];

  late String _currentQuote;
  String _selectedPeriod = "Last Month";

  final Map<String, Map<String, dynamic>> _data = {
    "Last Week": {
      "impact": [
        {"icon": Icons.park, "title": "Land", "value": "40", "unit": "sq.m", "color": Colors.green},
        {"icon": Icons.water_drop, "title": "Water", "value": "2,500", "unit": "L", "color": Colors.blue},
        {"icon": Icons.cloud, "title": "CO₂", "value": "25.5", "unit": "kg", "color": Colors.orange},
      ],
      "activities": [
        {"icon": Icons.shopping_bag, "value": "3", "label": "Plastic Free\nShopping", "color": Colors.blue},
        {"icon": Icons.grass, "value": "2", "label": "Grown Own\nGroceries", "color": Colors.green},
        {"icon": Icons.store, "value": "1", "label": "Bought Local\nProduct", "color": Colors.orange},
      ],
    },
    "Last Month": {
      "impact": [
        {"icon": Icons.park, "title": "Land", "value": "134", "unit": "sq.m", "color": Colors.green},
        {"icon": Icons.water_drop, "title": "Water", "value": "8,284", "unit": "L", "color": Colors.blue},
        {"icon": Icons.cloud, "title": "CO₂", "value": "86.3", "unit": "kg", "color": Colors.orange},
      ],
      "activities": [
        {"icon": Icons.shopping_bag, "value": "12", "label": "Plastic Free\nShopping", "color": Colors.blue},
        {"icon": Icons.grass, "value": "11", "label": "Grown Own\nGroceries", "color": Colors.green},
        {"icon": Icons.store, "value": "9", "label": "Bought Local\nProduct", "color": Colors.orange},
      ],
    },
    "Last Year": {
      "impact": [
        {"icon": Icons.park, "title": "Land", "value": "1,560", "unit": "sq.m", "color": Colors.green},
        {"icon": Icons.water_drop, "title": "Water", "value": "102,000", "unit": "L", "color": Colors.blue},
        {"icon": Icons.cloud, "title": "CO₂", "value": "1,050", "unit": "kg", "color": Colors.orange},
      ],
      "activities": [
        {"icon": Icons.shopping_bag, "value": "120", "label": "Plastic Free\nShopping", "color": Colors.blue},
        {"icon": Icons.grass, "value": "110", "label": "Grown Own\nGroceries", "color": Colors.green},
        {"icon": Icons.store, "value": "95", "label": "Bought Local\nProduct", "color": Colors.orange},
      ],
    },
  };

  @override
  void initState() {
    super.initState();
    _currentQuote = _ecoQuotes[Random().nextInt(_ecoQuotes.length)];
  }

  void _refreshQuote() {
    setState(() {
      _currentQuote = _ecoQuotes[Random().nextInt(_ecoQuotes.length)];
    });
  }

  void _selectPeriod(String period) {
    if (_data.containsKey(period)) {
      setState(() {
        _selectedPeriod = period;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentImpact = (_data[_selectedPeriod]?["impact"] as List<dynamic>?) ?? [];
    final currentActivities = (_data[_selectedPeriod]?["activities"] as List<dynamic>?) ?? [];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          "🌱 Welcome Back!",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          "Here’s a quick look at your eco-friendly journey today:",
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
        const SizedBox(height: 20),

        Center(
          child: Column(
            children: const [
              Text(
                "You're on a 5-day eco streak! 🔥",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.green.shade50,
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: ["Last Week", "Last Month", "Last Year"].map((period) {
                    return FilterChip(
                      label: Text(period),
                      selected: _selectedPeriod == period,
                      selectedColor: Colors.green.shade100,
                      onSelected: (_) => _selectPeriod(period),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: currentImpact.map((item) {
                    return _buildImpactItem(
                      item["icon"] as IconData,
                      item["title"] as String,
                      item["value"] as String,
                      item["unit"] as String,
                      item["color"] as Color,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Top Activities",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: currentActivities.map((item) {
                    return _buildActivityItem(
                      item["icon"] as IconData,
                      item["value"].toString(),
                      item["label"] as String,
                      item["color"] as Color,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: Colors.green.shade50,
          child: const ListTile(
            leading: Icon(Icons.water_drop, color: Colors.blue, size: 30),
            title: Text("Water Saved"),
            subtitle: Text("You saved 15L today 💧"),
            trailing: Icon(Icons.check_circle, color: Colors.green),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: Colors.green.shade50,
          child: const ListTile(
            leading: Icon(Icons.directions_bike, color: Colors.orange, size: 30),
            title: Text("CO₂ Reduced"),
            subtitle: Text("Avoided 2.3kg emissions 🚴‍♂️"),
            trailing: Icon(Icons.check_circle, color: Colors.green),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: Colors.green.shade50,
          child: const ListTile(
            leading: Icon(Icons.eco, color: Colors.green, size: 30),
            title: Text("Habits Completed"),
            subtitle: Text("3 of 5 daily habits"),
            trailing: Icon(Icons.trending_up, color: Colors.green),
          ),
        ),
        const SizedBox(height: 16),
        _buildProgressSection(),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: _refreshQuote,
          child: Card(
            color: Colors.green.shade100,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.format_quote, color: Colors.green, size: 40),
                  const SizedBox(height: 8),
                  Text(
                    _currentQuote,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Tap to refresh 💚",
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget _buildImpactItem(
      IconData icon, String title, String value, String unit, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 6),
        Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(unit, style: const TextStyle(color: Colors.black54)),
      ],
    );
  }

  static Widget _buildActivityItem(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Colors.black54)),
      ],
    );
  }

  Widget _buildProgressSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.green.shade50,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Weekly Progress",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildProgressItem("Water Saved", 0.75, Colors.blue),
            _buildProgressItem("CO₂ Reduced", 0.55, Colors.orange),
            _buildProgressItem("Habits Completed", 0.6, Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressItem(String title, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.grey.shade300,
          color: color,
          minHeight: 8,
          borderRadius: BorderRadius.circular(8),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
