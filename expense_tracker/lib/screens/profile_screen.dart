import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.purple.withOpacity(0.1),
              child: Icon(Icons.person, size: 50, color: Colors.purple),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.account_balance_wallet, color: Colors.purple),
              title: Text('Accounts'),
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.purple),
              title: Text('Settings'),
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}