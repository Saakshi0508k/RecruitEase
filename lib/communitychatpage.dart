import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityChatPage extends StatefulWidget {
  final String studentUsername;

  CommunityChatPage({required this.studentUsername});

  @override
  _CommunityChatPageState createState() => _CommunityChatPageState();
}

class _CommunityChatPageState extends State<CommunityChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final CollectionReference _messages =
      FirebaseFirestore.instance.collection('messages');

  // Send message to Firestore
  void _sendMessage() async {
    if (_messageController.text.trim().isNotEmpty) {
      await _messages.add({
        'username': widget.studentUsername, // Use the passed username here
        'message': _messageController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      _messageController.clear(); // Clear message input
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Community Chat')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  _messages.orderBy('timestamp', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No messages yet.'));
                }

                // List of messages
                return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final messageData = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    final String username =
                        messageData['username'] ?? "Anonymous";
                    final String messageText = messageData['message'] ?? "";

                    return ListTile(
                      title: Text(username,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(messageText),
                    );
                  },
                );
              },
            ),
          ),
          // Message input field and send button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter your message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
