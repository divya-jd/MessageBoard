import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditDetailsScreen extends StatefulWidget {
  @override
  _EditDetailsScreenState createState() => _EditDetailsScreenState();
}

class _EditDetailsScreenState extends State<EditDetailsScreen> {
  final _nameController = TextEditingController();
  final _photoUrlController = TextEditingController();

  Future<void> _updateDetails() async {
    try {
      await FirebaseAuth.instance.currentUser?.updateDisplayName(_nameController.text);
      await FirebaseAuth.instance.currentUser?.updatePhotoURL(_photoUrlController.text);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Details updated successfully!")));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to update details: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Personal Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Display Name"),
            ),
            TextField(
              controller: _photoUrlController,
              decoration: InputDecoration(labelText: "Photo URL"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateDetails,
              child: Text("Update Details"),
            ),
          ],
        ),
      ),
    );
  }
}
