import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentProfilePage extends StatefulWidget {
  final String studentUsername;

  StudentProfilePage({required this.studentUsername});

  @override
  _StudentProfilePageState createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  late Future<QuerySnapshot> studentData;

  @override
  void initState() {
    super.initState();
    print('Fetching data for student: ${widget.studentUsername}');
    // Fetch student data based on the "username" field in Firestore
    studentData = FirebaseFirestore.instance
        .collection('students')
        .where('username',
            isEqualTo: widget.studentUsername) // Query by "username" field
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Profile"),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: studentData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            print('No documents found for username: ${widget.studentUsername}');
            return Center(child: Text("No data found for this username"));
          }

          // Log the data of the first document
          var student = snapshot.data!.docs[0].data() as Map<String, dynamic>;
          print('Fetched student data: $student');

          // Extract student information with null checks
          String name = student['name'] ?? 'No Name Available';
          String username = student['username'] ?? 'No Username Available';
          String cgpi = student['cgpi'] ?? 'No CGPI Available';
          String studentClass = student['class'] ?? 'No Class Available';
          String department =
              student['department'] ?? 'No Department Available';
          String email = student['email'] ?? 'No Email Available';
          String mobile = student['mobile'] ?? 'No Mobile Available';
          String yearOfPassing =
              student['yearOfPassing'] ?? 'No Year Available';
          String skills = student['skills'] ?? 'No Skills Available';
          String resumeUrl = student['resumeUrl'] ?? '';

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Image (CircleAvatar)
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                        'assets/profile.png'), // Replace with actual image path or URL if available
                  ),
                ),
                SizedBox(height: 20),

                // Displaying Student Details
                Text(
                  'Name: $name',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Username: $username',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'CGPI: $cgpi',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Class: $studentClass',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Department: $department',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Email: $email',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Mobile: $mobile',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Year of Passing: $yearOfPassing',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Skills: $skills',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),

                // Resume URL (Clickable link)
                resumeUrl.isNotEmpty
                    ? GestureDetector(
                        onTap: () async {
                          if (await canLaunch(resumeUrl)) {
                            await launch(resumeUrl);
                          } else {
                            throw 'Could not open the resume URL';
                          }
                        },
                        child: Text(
                          'Resume: Tap to View',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    : Container(), // If no resume URL, do not show the text
              ],
            ),
          );
        },
      ),
    );
  }
}
