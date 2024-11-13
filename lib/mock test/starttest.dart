import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Starttest extends StatefulWidget {
  final String mockTestId;

  const Starttest({super.key, required this.mockTestId});

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
    // Cancel any existing timer
    if (_timer.isActive) {
      _timer.cancel();
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime <= 0) {
        setState(() {
          isTimeUp = true;
        });
        timer.cancel();
      } else {
        setState(() {
          _remainingTime--;
        });
      }
    });
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

  void _submitQuiz() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Submitted'),
        content: const Text('Thank you for completing the quiz.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
