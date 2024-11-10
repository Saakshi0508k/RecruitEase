import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentNotificationPage extends StatefulWidget {
  const StudentNotificationPage({Key? key}) : super(key: key);

  @override
  _StudentNotificationPageState createState() =>
      _StudentNotificationPageState();
}

class _StudentNotificationPageState extends State<StudentNotificationPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // No need for the username check since you want to fetch all notifications
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Notifications'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : StreamBuilder<QuerySnapshot>(
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

                // Process the notifications
                List<NotificationItem> notifications =
                    snapshot.data!.docs.map((doc) {
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

  const NotificationCard({Key? key, required this.notification})
      : super(key: key); // Corrected to use named argument

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
      ),
    );
  }
}
