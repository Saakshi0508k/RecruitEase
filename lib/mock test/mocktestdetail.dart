import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MockTestDetailPage extends StatelessWidget {
  final String mockTestId;
  final String? studentUsername; // Make this optional

  const MockTestDetailPage({
    Key? key,
    required this.mockTestId,
    this.studentUsername, // Make this parameter optional
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0A2E4D),
        title: const Text('Mock Test Details', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // White back button
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('mockTests')
            .doc(mockTestId)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final mockTest = snapshot.data!;
          final questions = mockTest['questions'] as List<dynamic>;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final questionData = questions[index];
              final questionText = questionData['question'] as String;
              final options = List<String>.from(questionData['options']);
              final answer = questionData['answer'] as String;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Q${index + 1}. $questionText',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF0A2E4D),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: options.map((option) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              option,
                              style: const TextStyle(color: Colors.black87),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Answer: $answer',
                        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
