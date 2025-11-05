import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// -------------------------------
// User Model
// -------------------------------
class User {
  String name;
  String email;
  String phone;
  String bio;
  String? avatarPath;

  User({
    required this.name,
    required this.email,
    this.phone = '',
    this.bio = '',
    this.avatarPath,
  });
}

// -------------------------------
// Settings Screen (with Theme & Logout)
// -------------------------------
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _isDarkMode = false;
  bool _isLoggedOut = false;

  final User currentUser = User(
    name: "Nandni Thakur",
    email: "nandni@example.com",
    phone: "1234567890",
    bio: "I love sustainable living 🌱",
  );

  void _logout() {
    setState(() {
      _isLoggedOut = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Logged out successfully ✅"),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              _logout();
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
          backgroundColor: _isDarkMode ? Colors.grey[850] : Colors.green,
          actions: [
            IconButton(
              icon: Icon(
                _isDarkMode ? Icons.dark_mode : Icons.light_mode,
              ),
              onPressed: () => setState(() => _isDarkMode = !_isDarkMode),
            ),
          ],
        ),
        backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.grey[100],
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              "⚙️ Settings",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 16),

            // Profile
            Card(
              color: _isDarkMode ? Colors.grey[850] : Colors.white,
              child: ListTile(
                leading: const Icon(Icons.person, color: Colors.blue),
                title: const Text("Profile"),
                subtitle: const Text("View and edit your details"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProfileScreen(
                        user: currentUser,
                        isDarkMode: _isDarkMode,
                      ),
                    ),
                  ).then((_) => setState(() {}));
                },
              ),
            ),
            const SizedBox(height: 12),

            // Notifications toggle
            Card(
              color: _isDarkMode ? Colors.grey[850] : Colors.white,
              child: SwitchListTile(
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() => _notificationsEnabled = value);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(value
                          ? "Notifications enabled 🔔"
                          : "Notifications disabled 🔕"),
                    ),
                  );
                },
                secondary:
                const Icon(Icons.notifications, color: Colors.orange),
                title: const Text("Notifications"),
                subtitle: const Text("Manage reminders & alerts"),
              ),
            ),
            const SizedBox(height: 12),

            // Theme toggle
            Card(
              color: _isDarkMode ? Colors.grey[850] : Colors.white,
              child: SwitchListTile(
                value: _isDarkMode,
                onChanged: (value) {
                  setState(() => _isDarkMode = value);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(value
                          ? "Dark mode enabled 🌙"
                          : "Light mode enabled ☀️"),
                    ),
                  );
                },
                secondary: const Icon(Icons.color_lens, color: Colors.purple),
                title: const Text("Theme"),
                subtitle: const Text("Light / Dark mode"),
              ),
            ),
            const SizedBox(height: 12),

            // Logout
            Card(
              color: _isDarkMode ? Colors.grey[850] : Colors.white,
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text("Logout"),
                onTap: _showLogoutDialog,
              ),
            ),

            if (_isLoggedOut)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "You are logged out.",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
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

// -------------------------------
// Profile Screen (with image picker + theme)
// -------------------------------
class ProfileScreen extends StatefulWidget {
  final User user;
  final bool isDarkMode;
  const ProfileScreen({super.key, required this.user, required this.isDarkMode});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);
    _bioController = TextEditingController(text: widget.user.bio);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image =
    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (image != null) {
      setState(() {
        widget.user.avatarPath = image.path;
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        widget.user.name = _nameController.text.trim();
        widget.user.email = _emailController.text.trim();
        widget.user.phone = _phoneController.text.trim();
        widget.user.bio = _bioController.text.trim();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully ✅")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: widget.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          backgroundColor:
          widget.isDarkMode ? Colors.grey[850] : Colors.green,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: widget.user.avatarPath != null
                            ? FileImage(File(widget.user.avatarPath!))
                            : const AssetImage('assets/default_avatar.png')
                        as ImageProvider,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 18,
                          child:
                          Icon(Icons.edit, color: Colors.green.shade700),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty ? "Enter your name" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Enter your email";
                    final emailRegex = RegExp(
                        r"^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$");
                    if (!emailRegex.hasMatch(value)) return "Enter valid email";
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: "Phone",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _bioController,
                  decoration: const InputDecoration(
                    labelText: "Bio",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _saveProfile,
                  icon: const Icon(Icons.save),
                  label: const Text("Save Profile"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 24),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
