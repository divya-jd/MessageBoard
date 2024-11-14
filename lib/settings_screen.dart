import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: user != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Hello, ${user.displayName ?? user.email}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () => _logout(context),
                    child: Text('Log Out'),
                  ),
                  SizedBox(height: 20),
                  Text('Other settings options here'),
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
