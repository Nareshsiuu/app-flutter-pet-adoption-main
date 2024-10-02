import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileSettingsScreen extends StatefulWidget {
  @override
  _ProfileSettingsScreenState createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  User? user;
  File? _imageFile;

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    _loadUserProfile(); // Load user profile on init
  }

  // Load user data from Firestore
  Future<void> _loadUserProfile() async {
    if (user != null) {
      try {
        DocumentSnapshot userData =
        await _firestore.collection('users').doc(user!.uid).get();
        if (userData.exists) {
          print('User data: ${userData.data()}');
          var userDataMap = userData.data() as Map<String, dynamic>;
          _phoneController.text = userDataMap['phone'] ?? '';
          _locationController.text = userDataMap['location'] ?? '';
          setState(() {}); // Update UI after loading user data
        }
      } catch (e) {
        print('Error loading user profile: $e');
      }
    }
  }

  // Pick image and upload to Firebase Storage
  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        await _uploadImage();
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  // Upload image to Firebase Storage
  Future<void> _uploadImage() async {
    if (_imageFile == null || user == null) return;
    try {
      String fileName = 'profile_${user!.uid}.jpg';
      Reference storageRef = _storage.ref().child('profile_images/$fileName');
      UploadTask uploadTask = storageRef.putFile(_imageFile!);

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Save the download URL to Firestore
      await _firestore.collection('users').doc(user!.uid).set({
        'profileImageUrl': downloadUrl,
      }, SetOptions(merge: true));

      setState(() {}); // Update UI to reflect image upload
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  // Save user changes to Firestore
  Future<void> _saveChanges() async {
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user!.uid).set({
          'phone': _phoneController.text,
          'location': _locationController.text,
        }, SetOptions(merge: true));

        // Show success Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Changes saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        // Show error Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Save changes failed!'),
            backgroundColor: Colors.red,
          ),
        );
        print('Error saving changes: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Image Section
              GestureDetector(
                onTap: _pickImage,
                child: FutureBuilder<DocumentSnapshot>(
                  future: _firestore.collection('users').doc(user!.uid).get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.grey,
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.grey,
                      );
                    }

                    var userData = snapshot.data?.data() as Map<String, dynamic>?;
                    String? profileImageUrl = userData?['profileImageUrl'];

                    return CircleAvatar(
                      radius: 80,
                      backgroundImage: profileImageUrl != null
                          ? NetworkImage(profileImageUrl)
                          : NetworkImage(
                          'https://randomuser.me/api/portraits/women/44.jpg'),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),

              // Name
              Text(
                user?.displayName ?? 'No Name',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),

              // Email
              ListTile(
                leading: Icon(Icons.email, size: 30, color: Colors.blueAccent),
                title: Text(
                  user?.email ?? 'No Email',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                subtitle: Text('Email'),
              ),

              // Phone Number Section
              ListTile(
                leading: Icon(Icons.phone, size: 30, color: Colors.blueAccent),
                title: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Enter phone number',
                    labelText: 'Phone',
                  ),
                ),
                subtitle: Text('Phone'),
              ),

              // Location Section
              ListTile(
                leading: Icon(Icons.location_on, size: 30, color: Colors.blueAccent),
                title: TextField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    hintText: 'Enter location',
                    labelText: 'Location',
                  ),
                ),
                subtitle: Text('Location'),
              ),

              // Save Button
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveChanges, // Call save changes function
                child: Text('Save Changes'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.blueAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
