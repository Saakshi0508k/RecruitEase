import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'starttest.dart';

class MockTeststudent extends StatelessWidget {
  const MockTeststudent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Mock Tests'),
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
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Test Conducted',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                        mockTestId:
                            mockTest.id, // Pass mockTest ID for navigation
                        context: context,
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
  final String mockTestId; // Add mockTestId for navigation
  final BuildContext context;

  const MockTestCard({
    required this.title,
    required this.studentCount,
    required this.context,
    required this.mockTestId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to MockTestDetailPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Starttest(mockTestId: mockTestId),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '$studentCount students attended',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            // Add the "Start Quiz" button
            ElevatedButton(
              onPressed: () {
                // Navigate to the quiz page or start the quiz logic
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Starttest(mockTestId: mockTestId),
                  ),
                );
              },
              child: const Text('Start Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
