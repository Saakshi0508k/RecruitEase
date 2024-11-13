import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recruite_ease/notification/studentnotif.dart';
import 'package:recruite_ease/mock test/mockteststudent.dart';

class LandingPageStudent extends StatefulWidget {
  final String studentUsername; // Add studentUsername to the constructor

  const LandingPageStudent(
      {super.key, required this.studentUsername}); // Constructor

  @override
  _LandingPageStudentState createState() => _LandingPageStudentState();
}

class _LandingPageStudentState extends State<LandingPageStudent> {
  int _currentIndex = 0;
  String studentName = '';
  late String studentUsername; // Declare studentUsername
  List<Map<String, dynamic>> forYouJobs = [];
  List<Map<String, dynamic>> upcomingOpportunities = [];
  bool isLoading = true;

  // Firestore references
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    studentUsername =
        widget.studentUsername; // Get the studentUsername passed from login
    _fetchStudentData();
    _fetchJobData();
  }

  // Fetch student name based on the username entered during login
  Future<void> _fetchStudentData() async {
    // Query the Firestore collection for the student document using username
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('students')
          .where('username',
              isEqualTo: studentUsername) // Match the username field
          .get();

      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot studentDoc = snapshot.docs.first;
        setState(() {
          studentName =
              studentDoc['name'] ?? 'Student'; // Retrieve name from Firestore
          isLoading = false; // Set loading to false after data is fetched
        });
      } else {
        setState(() {
          studentName = 'Student Not Found'; // Show error if student not found
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

  // Fetch jobs from Firebase Firestore for 'For You' and 'Upcoming Opportunities'
  Future<void> _fetchJobData() async {
    try {
      QuerySnapshot jobSnapshot = await _firestore.collection('jobs').get();
      List<Map<String, dynamic>> forYouJobsTemp = [];
      List<Map<String, dynamic>> upcomingOpportunitiesTemp = [];

      jobSnapshot.docs.forEach((jobDoc) {
        String jobTitle = jobDoc['jobTitle'] ?? 'No Title';
        String companyName = jobDoc['companyName'] ?? 'No Company';
        String jobLog = jobDoc['jobDescription'] ?? 'No Description';
        String imageUrl = jobDoc['imageUrl'] ?? ''; // Fetching the image URL

        // For demo, we just divide jobs into two categories
        forYouJobsTemp.add({
          'title': jobTitle,
          'company': companyName,
          'log': jobLog,
          'imageUrl': imageUrl, // Add image URL here
        });
        {
          upcomingOpportunitiesTemp.add({
            'title': jobTitle,
            'company': companyName,
            'log': jobLog,
            'imageUrl': imageUrl, // Add image URL here
          });
        }
      });

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
    studentUsername =
        widget.studentUsername; // Get the studentUsername passed from login
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
                    ? const CircularProgressIndicator() // Show loading indicator
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
          ? const Center(
              child: CircularProgressIndicator()) // Show loading if fetching
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 170,
                        decoration: BoxDecoration(
                          color: Colors.indigo[900],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Insight drives impact',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Know the role, know the company',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'make your mark.',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: const Text(
                      'For You',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: const Text(
                      'Upcoming Opportunities',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
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
                builder: (context) => MockTeststudent(),
              ),
            );
          }
        },
        backgroundColor: Colors.indigo[900],
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
