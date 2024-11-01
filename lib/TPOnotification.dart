import 'package:flutter/material.dart';
import 'TPOaddnotification.dart'; // Adjust the import path as necessary

class NotificationPage extends StatelessWidget {
  final List<NotificationItem> notifications = [
    NotificationItem(
      title: 'TCS Placement Meeting',
      subtitle:
          'Dear students, TCS company has arrived on campus for placement. A meeting has been scheduled on 12th March 2023 at 12 pm sharp in Room A.',
      timeAgo: '18 hours ago',
    ),
    NotificationItem(
      title: 'Congratulations!!!',
      subtitle:
          'Congratulations! You have been selected for this job at Wipro! Please check your email for further instructions.',
      timeAgo: '4 days ago',
    ),
    NotificationItem(
      title: 'Check Your Email',
      subtitle:
          'The company will contact you through your email so please keep checking your mail.',
      timeAgo: '4 days ago',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return NotificationCard(notification: notifications[index]);
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
}

class NotificationItem {
  final String title;
  final String subtitle;
  final String timeAgo;

  NotificationItem({
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
            _showDeleteConfirmationDialog(context);
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove Notification'),
          content: Text('Are you sure you want to delete this notification?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('NO'),
            ),
            TextButton(
              onPressed: () {
                // Delete the notification here
                // For example, remove it from the list
                // and update the UI accordingly
                Navigator.pop(context); // Close the dialog
              },
              child: Text('REMOVE NOTIFICATION'),
            ),
          ],
        );
      },
    );
  }
}