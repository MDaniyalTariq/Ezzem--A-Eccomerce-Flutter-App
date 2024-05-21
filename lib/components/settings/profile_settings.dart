import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileSettingsPage extends StatefulWidget {
  @override
  _ProfileSettingsPageState createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _displayName = '';
  String _email = '';
  String _phone = '';
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        _fetchUserData();
      }
    });
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _email = user.email ?? '';
      });

      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('profiles')
          .doc(user.uid)
          .get();

      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        setState(() {
          _displayName = data['displayName'] ?? '';
          _phone = data['phone'] ?? '';
          _nameController.text = _displayName;
          _emailController.text = _email;
          _phoneController.text = _phone;
        });
      } else {
        setState(() {
          _displayName = _email.split('@')[0];
          _nameController.text = _displayName;
          _email = user.email!;
          _emailController.text = _email;
        });
      }
    }
  }

  Future<void> _updateUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('profiles')
          .doc(user.uid)
          .set({
        'displayName': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
      });
      setState(() {
        _displayName = _nameController.text;
        _email = _emailController.text;
        _phone = _phoneController.text;
      });

      _showSnackBar('Profile updated successfully');
    } else {
      _showSnackBar('User not found');
    }
  }

  Future<void> _pickImage() async {
    try {
      var status = await Permission.photos.request();
      if (status.isGranted) {
        final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          setState(() {
            _image = File(pickedFile.path);
          });
        } else {
          _showSnackBar('No image selected');
        }
      } else {
        _showSnackBar('Permission denied for accessing photos');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Profile Settings'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 64,
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                      ? Icon(
                          Icons.person,
                          size: 64,
                        )
                      : null,
                ),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Display Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              readOnly: false,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateUserData,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
