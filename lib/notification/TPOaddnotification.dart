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
      // Determine selected visibility options
      List<String> visibleTo = [];
      if (visibleToTPC) visibleTo.add('TPC');
      if (visibleToTeacher) visibleTo.add('Teacher');
      if (visibleToStudent) visibleTo.add('Student');
      if (visibleToAll) visibleTo = ['All'];

      // Add the notification to Firestore
      try {
        await FirebaseFirestore.instance.collection('notifications').add({
          'title': title,
          'message': message,
          'createdAt': Timestamp.now(),
          'visibleTo': visibleTo,
        });

        // Clear the input fields
        _titleController.clear();
        _messageController.clear();
        setState(() {
          visibleToTPC = false;
          visibleToTeacher = false;
          visibleToStudent = false;
          visibleToAll = false;
        });

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Notification added successfully!'),
        ));

        // Navigate back to the previous screen
        Navigator.pop(context);
      } catch (e) {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to add notification: $e'),
        ));
      }
    } else {
      // Show an error if the title or message is empty
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter both title and message'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Notification'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
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
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _messageController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Text('Visible to:', style: TextStyle(fontWeight: FontWeight.bold)),
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
            CheckboxListTile(
              title: Text('All'),
              value: visibleToAll,
              onChanged: (bool? value) {
                setState(() {
                  visibleToAll = value ?? false;
                  if (visibleToAll) {
                    // Uncheck other options if "All" is selected
                    visibleToTPC = false;
                    visibleToTeacher = false;
                    visibleToStudent = false;
                  }
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveNotification,
              child: Text('SUBMIT'),
            ),
          ],
        ),
      ),
    );
  }
}
