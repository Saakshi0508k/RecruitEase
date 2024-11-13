import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recruite_ease/notification/studentnotif.dart';
import 'package:recruite_ease/mock test/mockteststudent.dart';

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
  bool isLoading = true;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    studentUsername = widget.studentUsername;
    _fetchStudentData();
    _fetchJobData();
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
      print("Error fetching student data: $e");
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
        String jobTitle = jobDoc['jobTitle'] ?? 'No Title';
        String companyName = jobDoc['companyName'] ?? 'No Company';
        String jobLog = jobDoc['jobDescription'] ?? 'No Description';
        String imageUrl = jobDoc['imageUrl'] ?? '';

        forYouJobsTemp.add({
          'title': jobTitle,
          'company': companyName,
          'log': jobLog,
          'imageUrl': imageUrl,
        });

        upcomingOpportunitiesTemp.add({
          'title': jobTitle,
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
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/profile_pic.jpg'),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Card(
                      elevation: 4,
                      color: const Color(0xFF0A2E4D),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
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
                            const SizedBox(width: 10),
                            Image.asset(
                              'assets/manage_activities.png',
                              width: 50,
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'For You',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 230,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: forYouJobs.map((job) {
                        return _buildCarouselItem(
                          job['title'],
                          job['company'],
                          job['log'],
                          job['imageUrl'],
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Upcoming Opportunities',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 230,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: upcomingOpportunities.map((job) {
                        return _buildCarouselItem(
                          job['title'],
                          job['company'],
                          job['log'],
                          job['imageUrl'],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          if (index == 1) {
            // Navigate to StudentNotificationPage when "Notifications" is tapped
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StudentNotificationPage(),
              ),
            );
          } else if (index == 2) {
            // Navigate to MockTeststudent when "Mock Tests" is tapped
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    MockTeststudent(studentUsername: studentUsername),
              ),
            );
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
      ),
    );
  }

  Widget _buildCarouselItem(
      String title, String company, String log, String imageUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 200,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageUrl.isNotEmpty
                ? Image.network(imageUrl,
                    height: 100, width: 150, fit: BoxFit.cover)
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
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              log,
              style: const TextStyle(fontSize: 12, color: Colors.white),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
