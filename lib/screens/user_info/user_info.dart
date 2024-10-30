import 'package:flutter/material.dart';
import 'package:shopping_app/screens/authentication/login.dart';
import 'package:shopping_app/screens/user_info/report_error.dart';
import 'package:shopping_app/services/auth_service.dart';

class UserDetails extends StatelessWidget {
  final AuthService _auth = AuthService();

  UserDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _navigateToSettings(context),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _auth.getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No user data available.'));
          }

          final userInfo = snapshot.data!;
          final String userName = userInfo['name'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserProfile(userName), // Only pass userName
                const SizedBox(height: 20),
                _buildMenuList(context),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Builds the user profile section with a person icon and name.
  Widget _buildUserProfile(String userName) {
    return Column(
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 40,
              child: Icon(Icons.person, size: 40), // Person icon
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
      ],
    );
  }

  /// Builds the menu list for actions available to the user.
  Widget _buildMenuList(BuildContext context) {
    return Column(
      children: [
        _buildMenuItem(
          context,
          icon: Icons.campaign,
          title: 'Announcement',
          onTap: () => _showSnackBar(context, 'Announcement tapped!'),
        ),
        _buildMenuItem(
          context,
          icon: Icons.school,
          title: 'Tutorial',
          onTap: () => _showSnackBar(context, 'Tutorial tapped!'),
        ),
        _buildMenuItem(
          context,
          icon: Icons.error,
          title: 'Report Error',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReportErrorScreen()),
          ),
        ),
        _buildLogoutMenuItem(context),
      ],
    );
  }

  /// Builds a menu item.
  Widget _buildMenuItem(BuildContext context,
      {required IconData icon,
      required String title,
      required Function() onTap}) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon),
          title: Text(title),
          onTap: onTap,
        ),
        const Divider(),
      ],
    );
  }

  /// Builds the logout menu item.
  Widget _buildLogoutMenuItem(BuildContext context) {
    return _buildMenuItem(
      context,
      icon: Icons.logout,
      title: 'Logout',
      onTap: () => _showLogoutDialog(context),
    );
  }

  /// Shows a snackbar message.
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  /// Shows a confirmation dialog for logging out.
  void _showLogoutDialog(BuildContext context) {
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
                final result = await _auth.logoutUser();
                if (result == "failed") {
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const Login()), // Navigate to login screen
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  /// Navigates to the settings screen.
  void _navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreen()),
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
