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

  final Color primaryColor = Color(0xFF0A2E4D);
  final Color secondaryColor = Colors.white;

  @override
  void initState() {
    super.initState();
    studentData = FirebaseFirestore.instance
        .collection('students')
        .where('username', isEqualTo: widget.studentUsername)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        title: Text("Student Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // White back button
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: studentData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No data found for this username",
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            );
          }

          var student = snapshot.data!.docs[0].data() as Map<String, dynamic>;
          String name = student['name'] ?? 'No Name Available';
          String username = student['username'] ?? 'No Username Available';
          dynamic cgpi = student['cgpi'] ?? 'No CGPI Available';
          String studentClass = student['class'] ?? 'No Class Available';
          String department = student['department'] ?? 'No Department Available';
          String email = student['email'] ?? 'No Email Available';
          String mobile = student['mobile'] ?? 'No Mobile Available';
          String yearOfPassing = student['yearOfPassing'] ?? 'No Year Available';
          String skills = student['skills'] ?? 'No Skills Available';
          String resumeUrl = student['resumeUrl'] ?? '';

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile Image
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/profile.png'),
                        backgroundColor: primaryColor.withOpacity(0.1),
                      ),
                      SizedBox(height: 20),

                      // Name
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(height: 10),

                      // Other Details
                      _buildDetailRow("Username", username),
                      _buildDetailRow("CGPI", cgpi.toString()),
                      _buildDetailRow("Class", studentClass),
                      _buildDetailRow("Department", department),
                      _buildDetailRow("Email", email),
                      _buildDetailRow("Mobile", mobile),
                      _buildDetailRow("Year of Passing", yearOfPassing),
                      _buildDetailRow("Skills", skills),
                      SizedBox(height: 20),

                      // Resume Link
                      if (resumeUrl.isNotEmpty)
                        ElevatedButton.icon(
                          onPressed: () async {
                            if (await canLaunch(resumeUrl)) {
                              await launch(resumeUrl);
                            } else {
                              throw 'Could not open the resume URL';
                            }
                          },
                          icon: Icon(Icons.open_in_browser),
                          label: Text("View Resume", style: TextStyle(color: Colors.white),),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            iconColor: secondaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: primaryColor,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
