import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  // Dummy user data (you can fetch this from Firebase or local storage later)
  String name = "Nandni Thakur";
  String email = "nandni@example.com";
  String bio = "Eco Enthusiast 🌿 | Passionate about sustainable living 🌱";
  int streakDays = 12;
  int completedHabits = 34;

  Future<void> _pickImage() async {
    final XFile? image =
    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  void _editProfile() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        final TextEditingController nameController =
        TextEditingController(text: name);
        final TextEditingController bioController =
        TextEditingController(text: bio);

        return Padding(
          padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Edit Profile",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: bioController,
                  decoration: const InputDecoration(
                    labelText: "Bio",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      name = nameController.text;
                      bio = bioController.text;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Profile updated successfully ✅"),
                      ),
                    );
                  },
                  icon: const Icon(Icons.save),
                  label: const Text("Save Changes"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAchievements() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("🏆 Achievements"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            ListTile(
              leading: Icon(Icons.local_florist, color: Colors.green),
              title: Text("Completed 30+ eco habits"),
            ),
            ListTile(
              leading: Icon(Icons.water_drop, color: Colors.blue),
              title: Text("Saved 50+ liters of water"),
            ),
            ListTile(
              leading: Icon(Icons.eco, color: Colors.teal),
              title: Text("Planted 5 trees initiative"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: const Text("User Profile"),
        backgroundColor: Colors.green.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : const AssetImage('assets/profile_placeholder.png')
                    as ImageProvider,
                  ),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.camera_alt,
                        color: Colors.green.shade700, size: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 6),
            Text(email, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),
            Text(
              bio,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 24),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Icon(Icons.local_fire_department,
                            color: Colors.orange),
                        const SizedBox(height: 6),
                        Text("$streakDays Days",
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        const Text("Habit Streak"),
                      ],
                    ),
                    Column(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green),
                        const SizedBox(height: 6),
                        Text("$completedHabits",
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        const Text("Habits Done"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _showAchievements,
              icon: const Icon(Icons.emoji_events_outlined),
              label: const Text("View Achievements"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent.shade700,
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text("Back to Home"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
