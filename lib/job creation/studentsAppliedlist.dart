import 'package:flutter/material.dart';

class StudentAppliedPage extends StatelessWidget {
  final String jobId;

  const StudentAppliedPage({super.key, required this.jobId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Students Applied',
          style: TextStyle(color: Colors.white), // White text color
        ),
        backgroundColor: Color(0xFF0A2E4D), // AppBar background color
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // White back button
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
                itemCount: 2, // Replace with actual applicant count
                itemBuilder: (context, index) {
                  // Sample applicant data, replace with dynamic data
                  return ApplicantCard(
                    name: 'Saloni Mehta',
                    email: 'saloni19@gmail.com',
                    imageUrl: 'https://example.com/saloni_profile.jpg',
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
