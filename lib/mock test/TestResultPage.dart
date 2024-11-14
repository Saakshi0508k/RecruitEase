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
          title: Text('Submit Quiz'),
          content: Text('Are you sure you want to submit the quiz?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
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
              child: Text('View'),
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
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _submitQuiz(context),
          child: const Text('Submit Quiz'),
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
        title: const Text('Test Results'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Score: $score/$totalQuestions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: answers.length,
              itemBuilder: (context, index) {
                final answer = answers[index];
                final String questionText =
                    answer['questionText'] ?? 'No question text';

                // Safely retrieve selectedOption as an integer index
                final int selectedIndex = answer['selectedOption'] ?? 0;
                final List<String> options =
                    List<String>.from(answer['options'] ?? []);

                // Verify that selectedIndex is within bounds before accessing
                String selectedAnswer =
                    selectedIndex >= 0 && selectedIndex < options.length
                        ? options[selectedIndex]
                        : 'Invalid option';

                final String correctAnswer =
                    answer['correctAnswer'] ?? 'No correct answer';
                bool isCorrect = selectedAnswer.trim() == correctAnswer.trim();

                return ListTile(
                  title: Text(questionText),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Answer: $selectedAnswer',
                        style: TextStyle(
                          color: isCorrect ? Colors.green : Colors.red,
                        ),
                      ),
                      Text(
                        'Correct Answer: $correctAnswer',
                        style: const TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
