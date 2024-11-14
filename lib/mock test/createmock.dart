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
    _option1Controller.addListener(_updateDropdown);
    _option2Controller.addListener(_updateDropdown);
    _option3Controller.addListener(_updateDropdown);
    _option4Controller.addListener(_updateDropdown);
  }

  void _updateDropdown() {
    setState(() {});
  }

  List<DropdownMenuItem<String>> _buildDropdownItems() {
    return [
      if (_option1Controller.text.isNotEmpty)
        DropdownMenuItem(value: _option1Controller.text, child: Text(_option1Controller.text)),
      if (_option2Controller.text.isNotEmpty)
        DropdownMenuItem(value: _option2Controller.text, child: Text(_option2Controller.text)),
      if (_option3Controller.text.isNotEmpty)
        DropdownMenuItem(value: _option3Controller.text, child: Text(_option3Controller.text)),
      if (_option4Controller.text.isNotEmpty)
        DropdownMenuItem(value: _option4Controller.text, child: Text(_option4Controller.text)),
    ];
  }

  void _addQuestion() {
    if (_questionController.text.isNotEmpty &&
        _option1Controller.text.isNotEmpty &&
        _option2Controller.text.isNotEmpty &&
        _option3Controller.text.isNotEmpty &&
        _option4Controller.text.isNotEmpty &&
        _selectedAnswer != null) {
      setState(() {
        _questions.add({
          'question': _questionController.text,
          'options': [_option1Controller.text, _option2Controller.text, _option3Controller.text, _option4Controller.text],
          'answer': _selectedAnswer,
        });
        _questionNumber++;
      });

      _questionController.clear();
      _option1Controller.clear();
      _option2Controller.clear();
      _option3Controller.clear();
      _option4Controller.clear();
      _selectedAnswer = null;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Question added successfully!')));
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Last question removed.')));
    }
  }

  void _submitMockTest() async {
    if (_questions.isNotEmpty && _mockTitleController.text.isNotEmpty && _durationController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('mockTests').add({
        'title': _mockTitleController.text,
        'duration': int.parse(_durationController.text),
        'questions': _questions,
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Mock test created successfully!')));
    } else {
      _showErrorDialog();
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('Please fill out all fields and add at least one question.'),
          actions: <Widget>[
            TextButton(child: const Text('OK'), onPressed: () => Navigator.of(context).pop()),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
title: Text(
          'Create Mock Test',
          style: TextStyle(color: Colors.white), // White text color
        ),        backgroundColor: Color(0xFF0A2E4D),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // White back button
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(icon: Icon(Icons.save, color: Colors.white), onPressed: _submitMockTest),
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
                decoration: InputDecoration(
                  labelText: 'Mock Title',
                  labelStyle: TextStyle(color: Color(0xFF0A2E4D)),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _durationController,
                decoration: InputDecoration(
                  labelText: 'Duration (in minutes)',
                  prefixIcon: Icon(Icons.timer, color: Color(0xFF0A2E4D)),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              Text(
                'Question $_questionNumber',
                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0A2E4D)),
              ),
              SizedBox(height: 8),
              _buildQuestionCard(),
              if (_questions.isNotEmpty)
                ..._questions.map((question) => _buildSavedQuestionCard(question)).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _questionController,
              decoration: InputDecoration(
                labelText: 'Question',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            _buildOptionField(_option1Controller, 'Option 1'),
            _buildOptionField(_option2Controller, 'Option 2'),
            _buildOptionField(_option3Controller, 'Option 3'),
            _buildOptionField(_option4Controller, 'Option 4'),
            DropdownButtonFormField<String>(
              value: _selectedAnswer,
              items: _buildDropdownItems(),
              onChanged: (newValue) {
                setState(() {
                  _selectedAnswer = newValue;
                });
              },
              decoration: InputDecoration(labelText: 'Correct Answer'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _addQuestion,
                  child: Text('Add Question', style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0A2E4D)),
                ),
                TextButton(
                  onPressed: _removeLastQuestion,
                  child: const Text('Remove Last'),
                  style: TextButton.styleFrom(iconColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.radio_button_unchecked, color: Color(0xFF0A2E4D)),
        ),
      ),
    );
  }

  Widget _buildSavedQuestionCard(Map<String, dynamic> question) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: Color(0xFF0A2E4D).withOpacity(0.05),
      child: ListTile(
        title: Text(question['question'], style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0A2E4D))),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Options: ${question['options'].join(", ")}', style: TextStyle(color: Color(0xFF0A2E4D))),
            Text('Answer: ${question['answer']}', style: TextStyle(color: Color(0xFF0A2E4D))),
          ],
        ),
      ),
    );
  }
}
