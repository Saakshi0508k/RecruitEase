import 'package:flutter/material.dart';
import 'package:recruite_ease/StudentDatabase.dart';
import 'package:recruite_ease/TPClist.dart';
import 'package:recruite_ease/mock%20test/mocktest.dart';
import '/notification/TPOnotification.dart';

class LandingPageTeacher extends StatefulWidget {
  const LandingPageTeacher({super.key});

  @override
  _LandingPageTeacherState createState() => _LandingPageTeacherState();
}

class _LandingPageTeacherState extends State<LandingPageTeacher> {
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
            SizedBox(width: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D013F),
                  ),
                ),
                Text(
                  'Teacher',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D013F),
                  ),
                ),
              ],
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
              color: Color(0xFF0A2E4D),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
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
                          'Handle all the placement\nrelated activities here with us.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    // Larger image on the right side
                    Image.asset(
                      'assets/manage_activity.png', // Replace with actual image path
                      width: 100,
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            // "Administer" text field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Administer',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
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
                  _buildStudentDbGridItem(),
                  _buildMockTestGridItem(),
                  _buildAlertsGridItem(),
                  _buildCoordinatorGridItem(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStudentDbGridItem() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentDb(), // Navigate to TPOjobs page
          ),
        );
      },
      child: Card(
        elevation: 2,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.lightBlue[100],
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                child: Image.asset(
                  'assets/student_applied.png', // Path to your image
                  fit: BoxFit.cover,
                  width: 70,
                  height: 70,
                ),
              ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Students',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMockTestGridItem() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MockTest(), // Navigate to TPOjobs page
          ),
        );
      },
      child: Card(
        elevation: 2,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.lightBlue[100],
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                child: Image.asset(
                  'assets/test.png', // Path to your image
                  fit: BoxFit.cover,
                  width: 70,
                  height: 70,
                ),
              ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Mock Test',
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
        elevation: 2,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.lightBlue[100],
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                child: Image.asset(
                  'assets/notification.png', // Path to your image
                  fit: BoxFit.cover,
                  width: 70,
                  height: 70,
                ),
              ),
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

  Widget _buildCoordinatorGridItem() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlacementOfficerScreen(), 
          ),
        );
      },
      child: Card(
        elevation: 2,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.lightBlue[100],
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                child: Image.asset(
                  'assets/coordinator.png', // Path to your image
                  fit: BoxFit.cover,
                  width: 70,
                  height: 70,
                ),
              ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Coordinator',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
