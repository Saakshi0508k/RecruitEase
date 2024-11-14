import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentNotificationPage extends StatelessWidget {
  final CollectionReference notificationsCollection =
      FirebaseFirestore.instance.collection('notifications');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(color: Colors.white), // White text color
        ),
        backgroundColor: Color(0xFF0A2E4D), // AppBar background color
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // White back button
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("notifications")
                  .where("visibleTo",
                      arrayContainsAny: ['Student', 'All']).snapshots(),
              builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No notifications available'));
          }

          List<NotificationItem> notifications = snapshot.data!.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            return NotificationItem(
              id: doc.id,
              title: data['title'] ?? 'No Title',
              subtitle: data['message'] ?? 'No Content',
              timeAgo: _timeAgo(data['createdAt'] as Timestamp),
            );
          }).toList();

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return NotificationCard(notification: notifications[index]);
            },
          );
        },
      ),
    );
  }

  String _timeAgo(Timestamp timestamp) {
    final DateTime date = timestamp.toDate();
    final Duration diff = DateTime.now().difference(date);
    if (diff.inDays > 1) return '${diff.inDays} days ago';
    if (diff.inHours > 1) return '${diff.inHours} hours ago';
    return '${diff.inMinutes} minutes ago';
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String subtitle;
  final String timeAgo;

  NotificationItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.timeAgo,
  });
}

class NotificationCard extends StatelessWidget {
  final NotificationItem notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        leading: Icon(Icons.notifications, color: Color(0xFF0A2E4D)),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.subtitle,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            SizedBox(height: 4),
            Text(
              notification.timeAgo,
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            _showDeleteConfirmationDialog(context, notification.id);
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, String notificationId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove Notification'),
          content: Text('Are you sure you want to delete this notification?'),
          backgroundColor: Colors.white,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('NO', style: TextStyle(color: Colors.blue)),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('notifications')
                    .doc(notificationId)
                    .delete();
                Navigator.pop(context);
              },
              child: Text(
                'REMOVE NOTIFICATION',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}


