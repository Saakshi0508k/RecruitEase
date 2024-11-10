import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recruite_ease/signin/extradetail.dart'; // Ensure this is correctly imported

class Studentsignin extends StatefulWidget {
  @override
  _StudentsigninState createState() => _StudentsigninState();
}

class _StudentsigninState extends State<Studentsignin> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  // Placeholder image URL
  final String _placeholderImageUrl =
      'https://www.example.com/assets/profile_placeholder.png';

  // Save basic details to Firestore
  Future<void> _saveDataAndNext() async {
    String username = _usernameController.text;
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String mobile = _mobileController.text;

    // Validate input
    if (username.isEmpty ||
        name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        mobile.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please fill in all fields')));
      return;
    }

    // Save basic details to Firestore under a collection 'students'
    try {
      await FirebaseFirestore.instance.collection('students').add({
        'username': username,
        'name': name,
        'email': email,
        'password': password,
        'mobile': mobile,
        'profileImage': _placeholderImageUrl,
      });

      // Navigate to the ExtraDetailsPage with the username passed to it
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExtraDetailsPage(username: username),
        ),
      );
    } catch (e) {
      // Handle Firestore errors here
      print("Error saving data: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error saving data')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50.0,
                backgroundImage: NetworkImage(_placeholderImageUrl),
              ),
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: _mobileController,
              decoration: InputDecoration(labelText: 'Mobile'),
            ),
            ElevatedButton(
              onPressed: _saveDataAndNext, // Save data and go to next page
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
