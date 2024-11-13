import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Starttest extends StatefulWidget {
  final String mockTestId;
  final String studentUsername; // Add this line

  const Starttest({
    Key? key,
    required this.mockTestId,
    required this.studentUsername, // Make studentUsername a required parameter
  }) : super(key: key);

  @override
  _StarttestState createState() => _StarttestState();
}

class _StarttestState extends State<Starttest> {
  late List<Map<String, dynamic>> questions = [];
  int currentQuestionIndex = 0;
  late Timer _timer =
      Timer(Duration.zero, () {}); // Initialize with a dummy timer
  int _remainingTime = 600; // Default time
  bool isTimeUp = false;
  int totalMarks = 0;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel(); // Cancel timer safely if it's active
    }
    super.dispose();
  }

  Future<void> _loadQuestions() async {
    try {
      var docSnapshot = await FirebaseFirestore.instance
          .collection('mockTests')
          .doc(widget.mockTestId)
          .get();

      if (docSnapshot.exists) {
        var mockTestData = docSnapshot.data();
        if (mockTestData != null) {
          _remainingTime =
              mockTestData['duration'] * 60 ?? 600; // Fetch duration in minutes
          var questionsList = mockTestData['questions'] as List<dynamic>;

          questions = questionsList.map((questionData) {
            return {
              'questionText': questionData['question'],
              'options': List<String>.from(questionData['options']),
              'correctAnswer':
                  questionData['answer'], // Store the correct answer
              'selectedOption': null,
            };
          }).toList();

          setState(() {}); // Trigger UI update after loading questions
          _startTimer();
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading questions: $e')),
      );
    }
  }

  void _startTimer() {
    if (_timer.isActive) {
      _timer.cancel();
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime <= 0) {
        setState(() {
          isTimeUp = true;
        });
        timer.cancel();
        _submitQuiz(); // Automatically submit when time is up
      } else {
        setState(() {
          _remainingTime--;
        });
      }
    });
  }

  void _calculateScore() {
    totalMarks = 0;

    for (var question in questions) {
      // Ensure selectedOption is not null and check it against the correct answer
      if (question['selectedOption'] != null) {
        int selectedIndex = question['selectedOption'];
        String selectedAnswer = question['options'][selectedIndex];

        // Compare the selected answer with the correct answer (stored as a string)
        if (selectedAnswer == question['correctAnswer']) {
          totalMarks++;
        }
      }
    }

    print('Total Marks: $totalMarks'); // Debug print to verify the score
  }

  Future<void> _submitQuiz() async {
    _calculateScore();

    try {
      // Ensure username and score are valid before submitting
      print('Submitting quiz for user: ${widget.studentUsername}');
      print('Score: $totalMarks');

      // Store student answers, username, and total marks in Firestore
      await FirebaseFirestore.instance.collection('mockTestResults').add({
        'username': widget.studentUsername, // Ensure username is not empty
        'mockTestId': widget.mockTestId,
        'submittedAt': FieldValue.serverTimestamp(),
        'score': totalMarks, // Ensure score is calculated correctly
        'answers': questions.map((question) {
          return {
            'questionText': question['questionText'],
            'selectedOption': question['selectedOption'] != null
                ? question['options'][question['selectedOption']]
                : null,
          };
        }).toList(),
      });
      print('Username: ${widget.studentUsername}');
      print('Score: $totalMarks');

      // Show a dialog to display the score
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Quiz Submitted'),
          content: Text(
              'Thank you for completing the quiz.\nYour Score: $totalMarks'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.pop(context); // Navigate back to the previous screen
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting quiz: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    var currentQuestion = questions[currentQuestionIndex];
    int minutes = _remainingTime ~/ 60;
    int seconds = _remainingTime % 60;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mock Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Time Remaining: $minutes:${seconds.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              currentQuestion['questionText'],
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            ...List.generate(currentQuestion['options'].length, (index) {
              return RadioListTile(
                value: index,
                groupValue: currentQuestion['selectedOption'],
                title: Text(currentQuestion['options'][index]),
                onChanged: (value) {
                  setState(() {
                    currentQuestion['selectedOption'] = value;
                  });
                },
              );
            }),
            const SizedBox(height: 20),
            currentQuestionIndex == questions.length - 1
                ? ElevatedButton(
                    onPressed: isTimeUp ? null : _submitQuiz,
                    child: const Text('Submit Quiz'),
                  )
                : ElevatedButton(
                    onPressed: isTimeUp ? null : _nextQuestion,
                    child: const Text('Next'),
                  ),
          ],
        ),
      ),
    );
  }

  void _nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    }
  }
}
