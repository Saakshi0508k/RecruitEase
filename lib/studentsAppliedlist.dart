import 'package:flutter/material.dart';

class StudentAppliedPage extends StatelessWidget {
  const StudentAppliedPage({super.key});

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
                  return ApplicantCard(
                    name: 'Saloni Mehta',
                    email: 'saloni19@gmail.com',
                    imageUrl: 'https://example.com/saloni_profile.jpg',
                  );
                },
              ),
            ),

            // Records
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

  const ApplicantCard({
    super.key,
    required this.name,
    required this.email,
    required this.imageUrl,
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
                // Handle select applicant
              },
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                // Handle reject applicant
              },
            ),
          ],
        ),
      ),
    );
  }
}