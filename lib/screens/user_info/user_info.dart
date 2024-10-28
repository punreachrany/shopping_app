import 'package:flutter/material.dart';
import 'package:shopping_app/screens/authentication/login.dart';
import 'package:shopping_app/services/auth_service.dart';

class UserDetails extends StatelessWidget {
  final AuthService _auth = AuthService();
  final String userName = '라비 버느리치';
  final String profileImageUrl =
      'https://www.w3schools.com/w3images/avatar2.png'; // Placeholder image
  final String token = "token"; // will change

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Handle Settings button tap
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Line 1: User Picture and Name
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(profileImageUrl),
                ),
                const SizedBox(width: 16),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Line 2: Announcement Tap
            ListTile(
              leading: const Icon(Icons.campaign, color: Colors.blue),
              title: const Text('Announcement'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Announcement tapped!')),
                );
              },
            ),
            const Divider(),

            // Line 3: Tutorial Tap
            ListTile(
              leading: const Icon(Icons.school, color: Colors.green),
              title: const Text('Tutorial'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tutorial tapped!')),
                );
              },
            ),
            const Divider(),

            // Line 4: Report Error
            ListTile(
              leading: const Icon(Icons.error, color: Colors.red),
              title: const Text('Report Error'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Report Error tapped!')),
                );
              },
            ),
            const Divider(),

            // Line 5: Logout
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.grey),
              title: const Text('Logout'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        TextButton(
                          child: const Text('Logout'),
                          onPressed: () async {
                            await _auth.logoutUser();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Login()), // Navigate to main app page
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Dummy Settings Screen
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: const Center(
        child: Text(
          'Settings Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
