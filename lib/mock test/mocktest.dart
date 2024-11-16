import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'createmock.dart';
import 'mocktestdetail.dart';

class MockTest extends StatelessWidget {
  const MockTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0A2E4D),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // White back button
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Mock Tests', style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search, color: Color(0xFF0A2E4D)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
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
                stream: FirebaseFirestore.instance.collection('mockTests').snapshots(),
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
                        mockTestId: mockTest.id,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateMockTestScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xFF0A2E4D),
      ),
    );
  }
}

class MockTestCard extends StatelessWidget {
  final String title;
  final int studentCount;
  final String? mockTestId;
  final BuildContext context;

  const MockTestCard({
    required this.title,
    required this.studentCount,
    required this.context,
    this.mockTestId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MockTestDetailPage(mockTestId: mockTestId!),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 3,
              blurRadius: 6,
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
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A2E4D),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.redAccent.shade400),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Mock'),
          content: const Text('Are you sure you want to delete this mock test?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              style: TextButton.styleFrom(
                iconColor: Colors.white,
                backgroundColor: Colors.redAccent.shade400,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                // Add delete logic here
              },
            ),
          ],
        );
      },
    );
  }
}
