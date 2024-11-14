import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'starttest.dart';

class MockTeststudent extends StatelessWidget {
  final String studentUsername;

  const MockTeststudent({Key? key, required this.studentUsername})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // White back button
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Mock Tests', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF0A2E4D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Test Conducted',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0A2E4D)),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('mockTests')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final mockTests = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: mockTests.length,
                    itemBuilder: (context, index) {
                      var mockTest = mockTests[index];
                      return MockTestCard(
                        title: mockTest['title'],
                        studentCount: 0, // Placeholder for student count
                        mockTestId: mockTest.id, // Pass mockTest ID for navigation
                        studentUsername: studentUsername, // Pass studentUsername
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

class MockTestCard extends StatelessWidget {
  final String title;
  final int studentCount;
  final String mockTestId;
  final String studentUsername; // Add studentUsername here

  const MockTestCard({
    required this.title,
    required this.studentCount,
    required this.mockTestId,
    required this.studentUsername, // Add studentUsername as a required parameter
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Starttest(
              mockTestId: mockTestId,
              studentUsername: studentUsername, // Pass studentUsername to Starttest
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF0A2E4D),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '$studentCount students attended',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Starttest(
                      mockTestId: mockTestId,
                      studentUsername: studentUsername, // Pass studentUsername here as well
                    ),
                  ),
                );
              },
              child: const Text('Start Quiz'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0A2E4D),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
