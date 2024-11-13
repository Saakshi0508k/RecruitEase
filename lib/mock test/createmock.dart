import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateMockTestScreen extends StatefulWidget {
  const CreateMockTestScreen({super.key});

  @override
  _CreateMockTestScreenState createState() => _CreateMockTestScreenState();
}

class _CreateMockTestScreenState extends State<CreateMockTestScreen> {
  final _mockTitleController = TextEditingController();
  final _durationController = TextEditingController();
  final _questionController = TextEditingController();
  final _option1Controller = TextEditingController();
  final _option2Controller = TextEditingController();
  final _option3Controller = TextEditingController();
  final _option4Controller = TextEditingController();

  int _questionNumber = 1;
  List<Map<String, dynamic>> _questions = [];
  String? _selectedAnswer;

  @override
  void initState() {
    super.initState();
    // Add listeners to option controllers to update dropdown when options change
    _option1Controller.addListener(_updateDropdown);
    _option2Controller.addListener(_updateDropdown);
    _option3Controller.addListener(_updateDropdown);
    _option4Controller.addListener(_updateDropdown);
  }

  void _updateDropdown() {
    // Just rebuild the dropdown items without resetting the selected answer
    setState(() {});
  }

  List<DropdownMenuItem<String>> _buildDropdownItems() {
    return [
      if (_option1Controller.text.isNotEmpty)
        DropdownMenuItem(
            value: _option1Controller.text,
            child: Text(_option1Controller.text)),
      if (_option2Controller.text.isNotEmpty)
        DropdownMenuItem(
            value: _option2Controller.text,
            child: Text(_option2Controller.text)),
      if (_option3Controller.text.isNotEmpty)
        DropdownMenuItem(
            value: _option3Controller.text,
            child: Text(_option3Controller.text)),
      if (_option4Controller.text.isNotEmpty)
        DropdownMenuItem(
            value: _option4Controller.text,
            child: Text(_option4Controller.text)),
    ];
  }

  void _addQuestion() {
    if (_questionController.text.isNotEmpty &&
        _option1Controller.text.isNotEmpty &&
        _option2Controller.text.isNotEmpty &&
        _option3Controller.text.isNotEmpty &&
        _option4Controller.text.isNotEmpty &&
        _selectedAnswer != null) {
      _questions.add({
        'question': _questionController.text,
        'options': [
          _option1Controller.text,
          _option2Controller.text,
          _option3Controller.text,
          _option4Controller.text,
        ],
        'answer': _selectedAnswer,
      });

      _questionController.clear();
      _option1Controller.clear();
      _option2Controller.clear();
      _option3Controller.clear();
      _option4Controller.clear();
      _selectedAnswer = null;

      setState(() {
        _questionNumber++;
      });
    } else {
      _showErrorDialog();
    }
  }

  void _removeLastQuestion() {
    if (_questions.isNotEmpty) {
      setState(() {
        _questions.removeLast();
        _questionNumber--;
      });
    }
  }

  void _submitMockTest() async {
    _showSubmitConfirmationDialog();
  }

  void _showSubmitConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Submit Mock?'),
          content: const Text('Are you sure you want to add this mock test?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                try {
                  // Structure the data correctly
                  await FirebaseFirestore.instance.collection('mockTests').add({
                    'title': _mockTitleController.text,
                    'duration': int.parse(_durationController.text),
                    'createdAt': FieldValue.serverTimestamp(),
                    'questions': _questions
                        .map((question) => {
                              'question':
                                  question['question'], // Question comes first
                              'answer': question['answer'], // Answer second
                              'options': question['options'], // Options last
                            })
                        .toList(),
                  });

                  // Clear fields after successful submission
                  _mockTitleController.clear();
                  _durationController.clear();
                  _questions.clear();
                  setState(() {
                    _questionNumber = 1;
                  });

                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Navigate back after submission

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Mock test created successfully!')),
                  );
                } catch (e) {
                  Navigator.of(context).pop(); // Close dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to create mock test')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text(
              'Please fill out all fields and select a correct answer before adding the question.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Create Mock Test'),
        actions: [
          TextButton(
            onPressed: _submitMockTest,
            child: const Text('Submit'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _mockTitleController,
                decoration: const InputDecoration(
                  labelText: 'Mock Title',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _durationController,
                decoration: const InputDecoration(
                  labelText: 'Duration (in minutes)',
                  prefixIcon: Icon(Icons.timer),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Text(
                'Question $_questionNumber',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _questionController,
                decoration: const InputDecoration(
                  labelText: 'Question',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _option1Controller,
                decoration: const InputDecoration(
                  labelText: 'Option 1',
                  prefixIcon: Icon(Icons.radio_button_unchecked),
                ),
              ),
              TextField(
                controller: _option2Controller,
                decoration: const InputDecoration(
                  labelText: 'Option 2',
                  prefixIcon: Icon(Icons.radio_button_unchecked),
                ),
              ),
              TextField(
                controller: _option3Controller,
                decoration: const InputDecoration(
                  labelText: 'Option 3',
                  prefixIcon: Icon(Icons.radio_button_unchecked),
                ),
              ),
              TextField(
                controller: _option4Controller,
                decoration: const InputDecoration(
                  labelText: 'Option 4',
                  prefixIcon: Icon(Icons.radio_button_unchecked),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedAnswer,
                items: _buildDropdownItems(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedAnswer = newValue;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Correct Answer',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _addQuestion,
                    child: const Text('Add Question'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _removeLastQuestion,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_questions.isNotEmpty)
                Column(
                  children: _questions.map((question) {
                    return ListTile(
                      title: Text(question['question']),
                      subtitle: Text(
                          'Options: ${question['options'].join(", ")} | Answer: ${question['answer']}'),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
