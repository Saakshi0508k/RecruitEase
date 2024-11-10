import 'package:flutter/material.dart';
import '/notification/TPOnotification.dart';
import '/TPClist.dart'; // Import tpclist.dart
import '/job creation/TPOjobs.dart'; // Import TPOjobs.dart

class LandingPageTPO extends StatefulWidget {
  const LandingPageTPO({super.key});

  @override
  _LandingPageTPOState createState() => _LandingPageTPOState();
}

class _LandingPageTPOState extends State<LandingPageTPO> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Prevents back arrow
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.person, size: 50.0),
            SizedBox(width: 10.0),
            Text(
              'Administrator',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.0),
            // Top Card
            Card(
              elevation: 4,
              color: Colors.indigo[900],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 130,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Manage Activities',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Handle all the placement-related activities here with us.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),

            // Bottom Grid
            Flexible(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 8.0,
                children: [
                  _buildGridItem(Icons.people, '240', 'Student Database'),
                  _buildJobsGridItem(),
                  _buildGridItem(Icons.list, '7', 'Mock Test'),
                  _buildAlertsGridItem(),
                  _buildGridItem(Icons.person, '3', 'Placement Officer'),
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
        // Add navigation logic based on the title
        if (title == 'Student Database') {
          // Handle Student Database action
        } else if (title == 'Mock Test') {
          // Handle Mock Test action
        } else if (title == 'Placement Officer') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PlacementOfficerScreen()),
          );
        }
      },
      child: Card(
        elevation: 4,
        color: Color(0xFFFAF9F6),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Light blue circle
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.lightBlue[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 30.0),
              ),
              SizedBox(height: 8.0),
              Text(
                count,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.0),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobsGridItem() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JobsPage(), // Navigate to TPOjobs page
          ),
        );
      },
      child: Card(
        elevation: 4,
        color: Color(0xFFFAF9F6),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.lightBlue[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.work, size: 30.0),
              ),
              SizedBox(height: 8.0),
              Text(
                'Jobs',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlertsGridItem() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationPage(),
          ),
        );
      },
      child: Card(
        elevation: 4,
        color: Color(0xFFFAF9F6),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.lightBlue[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.notifications, size: 30.0),
              ),
              SizedBox(height: 8.0),
              Text(
                'Alerts',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
