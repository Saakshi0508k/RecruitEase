import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizPage extends StatelessWidget {
  final int score;
  final List<Map<String, dynamic>> answers;
  final int totalQuestions;

  QuizPage({
    Key? key,
    required this.score,
    required this.answers,
    required this.totalQuestions,
  }) : super(key: key);

  void _submitQuiz(BuildContext context) {
    // Show the confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Submit Quiz'),
          content: const Text('Are you sure you want to submit the quiz?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog first
                // Navigate to TestResultPage after dialog is closed
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TestResultPage(
                      score: score,
                      answers: answers,
                      totalQuestions: totalQuestions,
                    ),
                  ),
                );
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Page'),
        backgroundColor: Color(0xFF0A2E4D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _submitQuiz(context),
              child: const Text('Submit Quiz'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Color(0xFF0A2E4D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TestResultPage extends StatelessWidget {
  final int score;
  final List<Map<String, dynamic>> answers;
  final int totalQuestions;

  const TestResultPage({
    Key? key,
    required this.score,
    required this.answers,
    required this.totalQuestions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Results', style: TextStyle(color: Colors.white),),
        backgroundColor: Color(0xFF0A2E4D),
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
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Color(0xFF0A2E4D),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Your Score: $score/$totalQuestions',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: answers.length,
                itemBuilder: (context, index) {
                  final answer = answers[index];
                  final String questionText = answer['questionText'] ?? 'No question text';
                  final int selectedIndex = answer['selectedOption'] ?? 0;
                  final List<String> options = List<String>.from(answer['options'] ?? []);
                  String selectedAnswer = selectedIndex >= 0 && selectedIndex < options.length
                      ? options[selectedIndex]
                      : 'Invalid option';
                  final String correctAnswer = answer['correctAnswer'] ?? 'No correct answer';
                  bool isCorrect = selectedAnswer.trim() == correctAnswer.trim();

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        questionText,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Answer: $selectedAnswer',
                            style: TextStyle(
                              color: isCorrect ? Colors.green : Colors.red,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Correct Answer: $correctAnswer',
                            style: const TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: score / totalQuestions,
              backgroundColor: Colors.grey.shade200,
              color: Color(0xFF0A2E4D),
              minHeight: 10,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to home or another page
                Navigator.pop(context);
              },
              child: const Text('Back to Home', style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Color(0xFF0A2E4D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
