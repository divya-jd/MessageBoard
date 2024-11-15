import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display user information
            if (user != null) ...[
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user.photoURL ?? 'https://www.w3schools.com/w3images/avatar2.png'), // Default image if null
              ),
              SizedBox(height: 20),
              Text('Hello, ${user.displayName ?? user.email!}', 
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text('Email: ${user.email}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 30),
            ],

            // Settings options
            Text('Manage your settings:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            Divider(),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text('Change Password'),
              onTap: () {
                Navigator.pushNamed(context, '/change-password');
              },
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit Personal Details'),
              onTap: () {
                Navigator.pushNamed(context, '/edit-details');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log Out'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
