import 'package:flutter/material.dart';

class StudentAppliedPage extends StatelessWidget {
  final String jobId;

  const StudentAppliedPage({super.key, required this.jobId});

  @override
  Widget build(BuildContext context) {
    // List of sample students' data
    final List<Map<String, String>> students = [
      {
        'name': 'Sakshi',
        'email': 'sakshi@example.com',
        'imageUrl': 'assets/profile.png',
      },
      {
        'name': 'Shashank',
        'email': 'crce,9935.ce@gmail.com',
        'imageUrl': 'assets/profile.png',
      },
      {
        'name': 'Samarth',
        'email': 'crce.9855.ce@gmail.com',
        'imageUrl': 'assets/profile.png',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Students Applied',
          style: TextStyle(color: Colors.white), // White text color
        ),
        backgroundColor: Color(0xFF0A2E4D), // AppBar background color
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.white), // White back button
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),

            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount:
                    students.length, // Use the length of the students list
                itemBuilder: (context, index) {
                  // Get student data from the list
                  final student = students[index];
                  return ApplicantCard(
                    name: student['name']!,
                    email: student['email']!,
                    imageUrl: student['imageUrl']!,
                    jobId: jobId, // Pass jobId for possible future use
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

class ApplicantCard extends StatelessWidget {
  final String name;
  final String email;
  final String imageUrl;
  final String jobId; // Pass jobId to handle actions related to the job

  const ApplicantCard({
    super.key,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.jobId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(name),
        subtitle: Text(email),
      ),
    );
  }
}
