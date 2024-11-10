import 'package:flutter/material.dart';

class StudentAppliedPage extends StatelessWidget {
  final String jobId;

  const StudentAppliedPage({super.key, required this.jobId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Applied'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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

            // Applicants List
            const Text('Applicants'),
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

            // Records section
            const Text('Records'),
            // Add records section here (e.g., a list of past applications)
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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.check_circle),
              onPressed: () {
                // Handle select applicant (e.g., approve for the job)
                // For now, just show a message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Applicant selected for job $jobId')),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                // Handle reject applicant
                // For now, just show a message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Applicant rejected for job $jobId')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
