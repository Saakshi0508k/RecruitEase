import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'TPOaddnotification.dart'; // Adjust the import path as necessary

class NotificationPage extends StatelessWidget {
  final CollectionReference notificationsCollection =
      FirebaseFirestore.instance.collection('notifications');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: notificationsCollection
            .orderBy('createdAt', descending: true)
            .snapshots(),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNotificationScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
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
      child: ListTile(
        leading: Icon(Icons.notifications),
        title: Text(notification.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.subtitle),
            SizedBox(height: 4),
            Text(notification.timeAgo, style: TextStyle(fontSize: 12)),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete),
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
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('NO'),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('notifications')
                    .doc(notificationId)
                    .delete();
                Navigator.pop(context);
              },
              child: Text('REMOVE NOTIFICATION'),
            ),
          ],
        );
      },
    );
  }
}
