import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String username = "John Doe";
  String email = "john.doe@example.com";
  String role = "User";
  String profileImagePath = 'assets/profile_placeholder.png'; // Local placeholder image
  String? profileImageUrl; // URL for Firebase stored image

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // Load user profile data from Firebase
  Future<void> _loadUserProfile() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          username = userDoc['username'] ?? username;
          email = user.email ?? email;
          role = userDoc['role'] ?? role;
          profileImageUrl = userDoc['profileImageUrl'];
        });
      }
    }
  }

  // Save profile info to Firebase
  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final user = _auth.currentUser;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'username': username,
          'email': email,
          'role': role,
          'profileImageUrl': profileImageUrl,
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated!')),
        );
      }
    }
  }

  // Update profile picture and save to Firebase Storage
  Future<void> _changeProfilePicture() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final user = _auth.currentUser;
      if (user != null) {
        final ref = _storage.ref().child('profile_images/${user.uid}.jpg');
        await ref.putFile(File(pickedImage.path));
        profileImageUrl = await ref.getDownloadURL();

        setState(() {
          profileImagePath = pickedImage.path;
        });

        // Save the profile image URL in Firestore
        await _firestore.collection('users').doc(user.uid).update({
          'profileImageUrl': profileImageUrl,
        });
      }
    }
  }

  Widget _buildProfilePicture() {
    return GestureDetector(
      onTap: _changeProfilePicture,
      child: CircleAvatar(
        radius: 50,
        backgroundImage: profileImageUrl != null
            ? NetworkImage(profileImageUrl!)
            : AssetImage(profileImagePath) as ImageProvider,
        child: Align(
          alignment: Alignment.bottomRight,
          child: Icon(
            Icons.camera_alt,
            color: Colors.white,
            size: 25,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: _buildProfilePicture()), // Profile picture with on-tap to change
              SizedBox(height: 20),
              Text(
                'Profile Information',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: username,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                      onSaved: (value) => username = value!,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      initialValue: email,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      onSaved: (value) => email = value!,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      initialValue: role,
                      decoration: InputDecoration(
                        labelText: 'Role',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) => role = value!,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveProfile,
                      child: Text('Save Changes'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _changeProfilePicture,
                child: Text('Change Profile Picture'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
