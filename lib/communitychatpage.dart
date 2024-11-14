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
  final CollectionReference _messages = FirebaseFirestore.instance.collection('messages');

  // Send message to Firestore
  void _sendMessage() async {
    if (_messageController.text.trim().isNotEmpty) {
      await _messages.add({
        'username': widget.studentUsername,
        'message': _messageController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Community Chat',
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
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messages.orderBy('timestamp', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No messages yet.'));
                }

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final messageData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    final String username = messageData['username'] ?? "Anonymous";
                    final String messageText = messageData['message'] ?? "";

                    bool isCurrentUser = username == widget.studentUsername;

                    return Align(
                      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5.0),
                        padding: EdgeInsets.all(12.0),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                        decoration: BoxDecoration(
                          color: isCurrentUser ? Color(0xFF0A2E4D) : Color.fromARGB(255, 210, 210, 210),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.0),
                            topRight: Radius.circular(12.0),
                            bottomLeft: isCurrentUser ? Radius.circular(12.0) : Radius.zero,
                            bottomRight: isCurrentUser ? Radius.zero : Radius.circular(12.0),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              username,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isCurrentUser ? Colors.white : theme.primaryColorDark,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              messageText,
                              style: TextStyle(
                                color: isCurrentUser ? Colors.white : Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            color: Color.fromARGB(255, 201, 201, 201),
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: 'Enter your message',
                      filled: true,
                      fillColor: theme.cardColor,
                      contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Color(0xFF0A2E4D),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
