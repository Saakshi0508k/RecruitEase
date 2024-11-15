import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'TestResultPage.dart';

class Starttest extends StatefulWidget {
  final String mockTestId;
  final String studentUsername;

  const Starttest({
    Key? key,
    required this.mockTestId,
    required this.studentUsername,
  }) : super(key: key);

  @override
  _StarttestState createState() => _StarttestState();
}

class _StarttestState extends State<Starttest> {
  late String title = ""; // Initialize with an empty string
  late List<Map<String, dynamic>> questions = [];
  int currentQuestionIndex = 0;
  late Timer _timer = Timer(Duration.zero, () {}); // Default empty timer
  int _remainingTime = 600; // 10 minutes in seconds
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
      _timer.cancel();
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
          _remainingTime = mockTestData['duration'] * 60 ?? 600;
          var questionsList = mockTestData['questions'] as List<dynamic>;
          title = mockTestData['title'] ?? "Untitled Test";

          questions = questionsList.map((questionData) {
            return {
              'questionText': questionData['question'],
              'options': List<String>.from(questionData['options']),
              'correctAnswer': questionData['answer'],
              'selectedOption': null,
            };
          }).toList();

          setState(() {});
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
        _submitQuiz();
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
      if (question['selectedOption'] != null) {
        int selectedIndex = question['selectedOption'];
        String selectedAnswer = question['options'][selectedIndex];

        if (selectedAnswer == question['correctAnswer']) {
          totalMarks++;
        }
      }
    }
  }

  Future<void> _submitQuiz() async {
    _calculateScore();

    try {
      await FirebaseFirestore.instance.collection('mockTestResults').add({
        'title': title,
        'username': widget.studentUsername,
        'mockTestId': widget.mockTestId,
        'submittedAt': FieldValue.serverTimestamp(),
        'score': totalMarks,
        'answers': questions.map((question) {
          return {
            'questionText': question['questionText'],
            'selectedOption': question['selectedOption'] != null
                ? question['options'][question['selectedOption']]
                : null,
            'correctAnswer': question['correctAnswer'],
          };
        }).toList(),
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Quiz Submitted'),
          content: Text(
              'Thank you for completing the quiz.\nYour Score: $totalMarks'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TestResultPage(
                      score: totalMarks,
                      answers: questions,
                      totalQuestions: questions.length,
                    ),
                  ),
                );
              },
              child: const Text('View'),
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
        title: const Text(
          'Mock Test',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF0A2E4D),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.white), // White back button
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Time Remaining: $minutes:${seconds.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              currentQuestion['questionText'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                activeColor: Color(0xFF0A2E4D),
              );
            }),
            const SizedBox(height: 20),
            currentQuestionIndex == questions.length - 1
                ? ElevatedButton(
                    onPressed: isTimeUp ? null : _submitQuiz,
                    child: const Text('Submit Quiz'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0A2E4D),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  )
                : ElevatedButton(
                    onPressed: isTimeUp ? null : _nextQuestion,
                    child: const Text('Next'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0A2E4D),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
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
