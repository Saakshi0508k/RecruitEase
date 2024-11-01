import 'package:flutter/material.dart';
import 'TPOnotification.dart';
import 'TPClist.dart'; // Import tpclist.dart
import 'TPOjobs.dart'; // Import TPOjobs.dart

class LandingPageTPO extends StatefulWidget {
  const LandingPageTPO({super.key});

  @override
  _LandingPageTPOState createState() => _LandingPageTPOState();
}

class _LandingPageTPOState extends State<LandingPageTPO> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Top Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Manage Activities',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text('Handle all the placement-related activities here with us.'),
                    SizedBox(height: 16.0),
                    // Icon and Text
                    Row(
                      children: [
                        Icon(Icons.person, size: 40.0),
                        SizedBox(width: 8.0),
                        Text('Administer', style: TextStyle(fontSize: 16.0)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),

            // Bottom Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  _buildGridItem(Icons.people, '240', 'Student Database'),
                  _buildGridItem(Icons.work, '3', 'Jobs'),
                  _buildGridItem(Icons.list, '7', 'Mock Test'),
                  _buildGridItem(Icons.notifications_active, '3', 'Alerts'),
                  _buildGridItem(Icons.person, '3', 'TPC'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(IconData icon, String count, String title) {
    return GestureDetector(
      onTap: () {
        if (title == 'Alerts') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotificationPage(),
            ),
          );
        } else if (title == 'Placement Coordinator') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlacementOfficerScreen(),
            ),
          );
        } else if (title == 'Jobs') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JobsPage(), // Navigate to TPOjobs page
            ),
          );
        }
      },
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40.0),
              SizedBox(height: 8.0),
              Text(count, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              SizedBox(height: 4.0),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}
