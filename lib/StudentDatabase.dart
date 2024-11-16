import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'studentprofile.dart';

class StudentDb extends StatefulWidget {
  @override
  _StudentDbState createState() => _StudentDbState();
}

class _StudentDbState extends State<StudentDb> {
  final Color primaryColor = Color(0xFF0A2E4D);
  final Color secondaryColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Database', style: TextStyle(color: secondaryColor)),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: secondaryColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: secondaryColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('students').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(color: primaryColor));
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'No students found.',
                        style: TextStyle(color: primaryColor, fontSize: 18.0),
                      ),
                    );
                  }

                  final students = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final student = students[index].data() as Map<String, dynamic>;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentProfilePage(
                                studentUsername: student['username'],
                              ),
                            ),
                          );
                        },
                        child: StudentCard(
                          name: student['name'] ?? 'No Name',
                          email: student['email'] ?? 'No Email',
                          imageUrl: student['imageUrl'] ?? '',
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StudentCard extends StatelessWidget {
  final String name;
  final String email;
  final String imageUrl;

  const StudentCard({
    required this.name,
    required this.email,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: imageUrl.isNotEmpty
              ? NetworkImage(imageUrl)
              : AssetImage('assets/default_profile.png') as ImageProvider,
        ),
        title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(email),
      ),
    );
  }
}
