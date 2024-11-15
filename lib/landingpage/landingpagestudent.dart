import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recruite_ease/notification/notifications.dart';
import 'package:recruite_ease/mock%20test/mockteststudent.dart';
import 'package:recruite_ease/communitychatpage.dart';
import 'leaderboard.dart';
import 'package:recruite_ease/studentprofile.dart';

class LandingPageStudent extends StatefulWidget {
  final String studentUsername;

  const LandingPageStudent({super.key, required this.studentUsername});

  @override
  _LandingPageStudentState createState() => _LandingPageStudentState();
}

class _LandingPageStudentState extends State<LandingPageStudent> {
  int _currentIndex = 0;
  String studentName = '';
  late String studentUsername;
  List<Map<String, dynamic>> forYouJobs = [];
  List<Map<String, dynamic>> upcomingOpportunities = [];
  List<Map<String, dynamic>> leaderboardData = [];
  bool isLoading = true;
  bool isLeaderboardLoading = true;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    studentUsername = widget.studentUsername;
    _fetchStudentData();
    _fetchJobData();
    fetchLeaderboardData();
  }

  Future<void> fetchLeaderboardData() async {
    try {
      final snapshot = await _firestore
          .collection('mockTestResults')
          .orderBy('score', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final topScorerDoc = snapshot.docs.first.data();

        // Get the total number of questions from the answers array length
        final totalQuestions = topScorerDoc['answers']?.length ??
            0; // Total questions based on answers

        // Get the score from the result
        final score = topScorerDoc['score'] ?? 0;

        // Calculate the score as score/totalQuestions
        final scoreDisplay =
            totalQuestions > 0 ? '$score/$totalQuestions' : 'N/A';

        setState(() {
          leaderboardData = [
            {
              'testName': topScorerDoc['title'] ?? 'N/A',
              'username': topScorerDoc['username'] ?? 'Unnamed',
              'score': scoreDisplay, // Display score as score/totalQuestions
            }
          ];
          isLeaderboardLoading = false;
        });
      } else {
        setState(() {
          leaderboardData = [];
          isLeaderboardLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLeaderboardLoading = false;
      });
    }
  }

  Future<void> _fetchStudentData() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('students')
          .where('username', isEqualTo: studentUsername)
          .get();

      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot studentDoc = snapshot.docs.first;
        setState(() {
          studentName = studentDoc['name'] ?? 'Student';
          isLoading = false;
        });
      } else {
        setState(() {
          studentName = 'Student Not Found';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        studentName = 'Error fetching name';
        isLoading = false;
      });
    }
  }

  Future<void> _fetchJobData() async {
    try {
      QuerySnapshot jobSnapshot = await _firestore.collection('jobs').get();
      List<Map<String, dynamic>> forYouJobsTemp = [];
      List<Map<String, dynamic>> upcomingOpportunitiesTemp = [];

      for (var jobDoc in jobSnapshot.docs) {
        String jobRole = jobDoc['jobRole'] ?? 'No Title';
        String companyName = jobDoc['companyName'] ?? 'No Company';
        String jobLog = jobDoc['jobDescription'] ?? 'No Description';
        String imageUrl = jobDoc['imageUrl'] ?? '';

        forYouJobsTemp.add({
          'title': jobRole,
          'company': companyName,
          'log': jobLog,
          'imageUrl': imageUrl,
        });

        upcomingOpportunitiesTemp.add({
          'title': jobRole,
          'company': companyName,
          'log': jobLog,
          'imageUrl': imageUrl,
        });
      }

      setState(() {
        forYouJobs = forYouJobsTemp;
        upcomingOpportunities = upcomingOpportunitiesTemp;
      });
    } catch (e) {
      print("Error fetching job data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 2,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side of the app bar - Greeting and Student Name
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hello',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                isLoading
                    ? const CircularProgressIndicator()
                    : Text(
                        studentName.isNotEmpty ? studentName : 'Loading...',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
              ],
            ),
            // Right side of the app bar - Profile Avatar
            GestureDetector(
              onTap: () {
                // Navigate to the StudentProfilePage when the CircleAvatar is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentProfilePage(
                      studentUsername: studentUsername,
                    ),
                  ),
                );
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.transparent,
                child: Image.asset(
                    'assets/profile.png'), // Set the image for the profile
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  _buildHeaderCard(),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle('Leaderboard'),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LeaderboardPage()),
                          );
                        },
                        child: Text(
                          'View All',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildLeaderboardCard(),
                  const SizedBox(height: 20),

                  // Scrollable Chart Cards Section
                  _buildSectionTitle('Placement Statistics'),
                  SizedBox(
                    height: 250, // Fixed height for charts
                    child: PageView(
                      children: [
                        _buildBarChart(),
                        _buildDoughnutChart(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildSectionTitle('For You'),
                  const SizedBox(height: 10),
                  _buildHorizontalList(forYouJobs),
                  const SizedBox(height: 30),
                  _buildSectionTitle('Upcoming Opportunities'),
                  const SizedBox(height: 10),
                  _buildHorizontalList(upcomingOpportunities),
                  const SizedBox(height: 30),
                ],
              ),
            ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildHeaderCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        elevation: 4,
        color: Color(0xFF0A2E4D),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Insight drives impact',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Know the role, know the company,\nmake your mark.',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              Image.asset(
                'assets/know_your_job.png',
                width: 80,
                height: 80,
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
                barRods: [
                  BarChartRodData(y: 5, colors: [Colors.blue])
                ],
              ),
              BarChartGroupData(
                x: 2,
                barRods: [
                  BarChartRodData(y: 6, colors: [Colors.green])
                ],
              ),
              BarChartGroupData(
                x: 3,
                barRods: [
                  BarChartRodData(y: 2, colors: [Colors.orange])
                ],
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
              PieChartSectionData(
                  value: 50, color: Colors.blue, title: 'Comps'),
              PieChartSectionData(value: 30, color: Colors.green, title: 'ECS'),
              PieChartSectionData(
                  value: 10, color: Colors.orange, title: 'AIDS'),
              PieChartSectionData(value: 20, color: Colors.pink, title: 'Mech'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalList(List<Map<String, dynamic>> jobs) {
    return SizedBox(
      height: 230,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: jobs.map((job) {
          return _buildJobCard(
            job['title'],
            job['company'],
            job['log'],
            job['imageUrl'],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildJobCard(
      String title, String company, String log, String imageUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 240,
      height: 400,
      decoration: BoxDecoration(
        color: Color(0xFF0A2E4D),
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 17, 89, 152), Color(0xFF0A2E4D)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageUrl.isNotEmpty
                ? FittedBox(
                    fit: BoxFit.cover, // Ensures the image covers the rectangle
                    child: Image.network(
                      imageUrl,
                      height: 100, // Adjust height as needed
                      width: 200, // Adjust width as needed
                    ),
                  )
                : const Icon(Icons.image_not_supported, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 5),
            Text(
              company,
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Text(
                log,
                style: const TextStyle(fontSize: 12, color: Colors.white60),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardCard() {
    return isLeaderboardLoading
        ? const Center(child: CircularProgressIndicator())
        : Center(
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF0A2E4D),
                      Color.fromARGB(255, 17, 89, 152),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                width: MediaQuery.of(context).size.width * 0.85,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Test: ${leaderboardData[0]['testName']}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Top Scorer: ${leaderboardData[0]['username']}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Score: ${leaderboardData[0]['score']}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
        switch (index) {
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StudentNotificationPage()),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MockTeststudent(studentUsername: studentUsername)),
            );
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CommunityChatPage(studentUsername: studentUsername)),
            );
            break;
        }
      },
      backgroundColor: const Color(0xFF0A2E4D),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey[400],
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.notifications), label: 'Notifications'),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Mock Tests'),
        BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble), label: 'Community'),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }
}
