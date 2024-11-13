import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddNotificationScreen extends StatefulWidget {
  @override
  _AddNotificationScreenState createState() => _AddNotificationScreenState();
}

class _AddNotificationScreenState extends State<AddNotificationScreen> {
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  bool visibleToTPC = false;
  bool visibleToTeacher = false;
  bool visibleToStudent = false;
  bool visibleToAll = false;

  Future<void> _saveNotification() async {
    String title = _titleController.text;
    String message = _messageController.text;

    if (title.isNotEmpty && message.isNotEmpty) {
      List<String> visibleTo = [];
      if (visibleToTPC) visibleTo.add('TPC');
      if (visibleToTeacher) visibleTo.add('Teacher');
      if (visibleToStudent) visibleTo.add('Student');
      if (visibleToAll) visibleTo = ['All'];

      try {
        await FirebaseFirestore.instance.collection('notifications').add({
          'title': title,
          'message': message,
          'createdAt': Timestamp.now(),
          'visibleTo': visibleTo,
        });

        _titleController.clear();
        _messageController.clear();
        setState(() {
          visibleToTPC = false;
          visibleToTeacher = false;
          visibleToStudent = false;
          visibleToAll = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Notification added successfully!'),
        ));

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to add notification: $e'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter both title and message'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Notification',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF0A2E4D),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: TextStyle(color: Colors.grey[700]),
                      filled: true,
                      fillColor: Colors.grey[100],
                      prefixIcon: Icon(Icons.title, color: Color(0xFF0A2E4D)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Color(0xFF0A2E4D)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 16),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _messageController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: 'Message',
                      labelStyle: TextStyle(color: Colors.grey[700]),
                      filled: true,
                      fillColor: Colors.grey[100],
                      prefixIcon: Icon(Icons.message, color: Color(0xFF0A2E4D)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Color(0xFF0A2E4D)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 16),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text('Visible to:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF0A2E4D))),
                  const SizedBox(height: 8.0),
                  CheckboxListTile(
                    title: Text('TPC'),
                    value: visibleToTPC,
                    onChanged: (bool? value) {
                      setState(() {
                        visibleToTPC = value ?? false;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Teacher'),
                    value: visibleToTeacher,
                    onChanged: (bool? value) {
                      setState(() {
                        visibleToTeacher = value ?? false;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Student'),
                    value: visibleToStudent,
                    onChanged: (bool? value) {
                      setState(() {
                        visibleToStudent = value ?? false;
                      });
                    },
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: _saveNotification,
                    child: const Text('SUBMIT',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A2E4D),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckboxTile(
      String title, bool value, void Function(bool?) onChanged) {
    return CheckboxListTile(
      title: Text(title, style: const TextStyle(fontSize: 15)),
      activeColor: const Color(0xFF0A2E4D),
      value: value,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
    );
  }
}
