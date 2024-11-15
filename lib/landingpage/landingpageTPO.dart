import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:recruite_ease/StudentDatabase.dart';
import 'package:recruite_ease/TPClist.dart';
import 'package:recruite_ease/mock%20test/mocktest.dart';
import '/notification/TPOnotification.dart';
import '/job creation/TPOjobs.dart';

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
        elevation: 4,
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
                  'Admin',
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
  child: SingleChildScrollView( // Wrap entire content in SingleChildScrollView
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
                      'Get Started!',
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

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'Placement Statictics',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(height: 12.0),

        // Carousel of Charts
        SizedBox(
          height: 250, // Fixed height for charts
          child: PageView(
            children: [
              _buildBarChart(),
              _buildDoughnutChart(),
            ],
          ),
        ),

        SizedBox(height: 16.0),

        // "Administer" text field
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'Manage',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(height: 12.0),

        // Bottom Grid
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 8.0,
          shrinkWrap: true, // Allows GridView to adjust its size within a scrollable widget
          physics: NeverScrollableScrollPhysics(), // Prevent GridView from scrolling independently
          children: [
            _buildStudentDbGridItem(),
            _buildJobsGridItem(),
            _buildMockTestGridItem(),
            _buildAlertsGridItem(),
            _buildCoordinatorGridItem(),
          ],
        ),
      ],
    ),
  ),
),

    );
  }

  Widget _buildBarChart() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BarChart(
  BarChartData(
    titlesData: FlTitlesData(
      leftTitles: SideTitles(showTitles: true),
      bottomTitles: SideTitles(
        showTitles: true,
        getTitles: (double value) {
          switch (value.toInt()) {
            case 1:
              return 'Barclays';
            case 2:
              return 'Carwale';
            case 3:
              return 'GM';
            default:
              return '';
          }
        },
      ),
    ),
    borderData: FlBorderData(show: false),
    barGroups: [
      BarChartGroupData(
        x: 1,
        barRods: [BarChartRodData(y: 5, colors: [Colors.blue])],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [BarChartRodData(y: 6, colors: [Colors.green])],
      ),
      BarChartGroupData(
        x: 3,
        barRods: [BarChartRodData(y: 2, colors: [Colors.orange])],
      ),
    ],
  ),
),

      ),
    );
  }

  Widget _buildDoughnutChart() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PieChart(
          PieChartData(
            sections: [
              PieChartSectionData(value: 50, color: Colors.blue, title: 'Comps'),
              PieChartSectionData(value: 30, color: Colors.green, title: 'ECS'),
              PieChartSectionData(value: 10, color: Colors.orange, title: 'AIDS'),
              PieChartSectionData(value: 20, color: Colors.pink, title: 'Mech'),

            ],
          ),
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
            builder: (context) => StudentDb(),
          ),
        );
      },
      child: Card(
        elevation: 3,
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
                    'assets/student_applied.png',
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
        elevation: 3,
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
                  'assets/job.png', // Path to your image
                  fit: BoxFit.cover,
                  width: 70,
                  height: 70,
                ),
              ),
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
        elevation: 3,
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
        elevation: 3,
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
        elevation: 3,
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
