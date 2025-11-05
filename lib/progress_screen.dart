import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Example dynamic data (in real app, pass from HabitsScreen or backend)
    final int weeklyStreak = 6;
    final int achievements = 3;
    final double carbonImpact = 12.4;
    final List<double> weeklyProgress = [1, 1, 1, 0, 1, 1, 1]; // Mon-Sun habits

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          "📊 Your Progress",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),

        // Weekly Streak Card
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.calendar_today, color: Colors.green, size: 28),
                    SizedBox(width: 12),
                    Text("Weekly Streak",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                Text("You’ve completed habits $weeklyStreak days in a row 🔥"),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: weeklyStreak / 7,
                    minHeight: 10,
                    color: Colors.green,
                    backgroundColor: Colors.green.shade100,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, _) {
                              const days = ["M", "T", "W", "T", "F", "S", "S"];
                              if (value >= 0 && value < days.length) {
                                return Text(days[value.toInt()]);
                              }
                              return const Text("");
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            for (int i = 0; i < weeklyProgress.length; i++)
                              FlSpot(i.toDouble(), weeklyProgress[i]),
                          ],
                          isCurved: true,
                          color: Colors.green,
                          barWidth: 3,
                          dotData: FlDotData(show: true),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Achievements Card
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: const [
                    Icon(Icons.emoji_events, color: Colors.orange, size: 28),
                    SizedBox(width: 12),
                    Text("Achievements",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                Text("You’ve earned $achievements eco badges 🏆"),
                const SizedBox(height: 16),
                SizedBox(
                  height: 150,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 30,
                      sections: [
                        PieChartSectionData(
                          value: 40,
                          color: Colors.green,
                          title: "🌱",
                          radius: 50,
                        ),
                        PieChartSectionData(
                          value: 30,
                          color: Colors.orange,
                          title: "♻️",
                          radius: 45,
                        ),
                        PieChartSectionData(
                          value: 30,
                          color: Colors.blue,
                          title: "💧",
                          radius: 40,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Carbon Impact Card
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.show_chart, color: Colors.blue, size: 28),
                    SizedBox(width: 12),
                    Text("Carbon Impact",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                Text("Reduced $carbonImpact kg CO₂ this month 🌍"),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: carbonImpact / 20, // target = 20kg
                    minHeight: 12,
                    color: Colors.blue,
                    backgroundColor: Colors.blue.shade100,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Motivational Card
        Card(
          color: Colors.green.shade50,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: const [
                Icon(Icons.favorite, color: Colors.red, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Keep it up! Every eco-friendly choice makes a big difference 🌍✨",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
