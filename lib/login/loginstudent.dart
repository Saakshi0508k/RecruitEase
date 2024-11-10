import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recruite_ease/landingpage/landingpagestudent.dart';
import 'package:recruite_ease/signin/studentsignIN.dart';

class LoginPagestudent extends StatefulWidget {
  const LoginPagestudent({super.key});

  @override
  State<LoginPagestudent> createState() => _LoginPagestudentState();
}

class _LoginPagestudentState extends State<LoginPagestudent> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to handle login
  Future<void> _login() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    print("Username: $username");
    print("Password: $password");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LandingPageStudent(studentUsername: username),
      ),
    );

// Check if the username and password are not empty
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter both username and password'),
      ));
      return;
    }

    try {
      // Query Firestore to check if the username exists
      var querySnapshot = await _firestore
          .collection('students')
          .where('username', isEqualTo: username)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Username found, now check the password
        var userDoc = querySnapshot.docs.first;
        String storedPassword = userDoc[
            'password']; // Assuming 'password' is stored in the document

        if (storedPassword == password) {
          // If password matches, navigate to LandingPageStudent and pass the username
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  LandingPageStudent(studentUsername: username),
            ),
          );
        } else {
          // Incorrect password
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Incorrect password'),
          ));
        }
      } else {
        // Username not found
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Username not found'),
        ));
      }
    } catch (e) {
      // Handle errors such as network issues or Firestore issues
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred. Please try again later.'),
      ));
      print("Login error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to RoleSelectionPage
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login, // Call the login method
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            // Add "New to RecruitEase? Sign In" Text Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('New to RecruitEase?'),
                TextButton(
                  onPressed: () {
                    // Navigate to Student Sign In page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Studentsignin()),
                    );
                  },
                  child: Text('Sign In'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
