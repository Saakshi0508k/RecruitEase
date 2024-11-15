import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardPage extends StatefulWidget {
  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  List<Map<String, dynamic>> leaderboardData = [];
  bool isLeaderboardLoading = true;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    fetchLeaderboardData();
  }

  Future<void> fetchLeaderboardData() async {
    try {
      final snapshot = await _firestore.collection('mockTestResults').get();

      if (snapshot.docs.isNotEmpty) {
        Map<String, Map<String, dynamic>> topScorers = {};

        snapshot.docs.forEach((doc) {
          final data = doc.data();
          final testName = data['title'] ?? 'N/A';
          final score = data['score'] ?? 0;
          final answers = data['answers'] as List?;
          final totalQuestions = answers?.length ?? 0;
          final scoreDisplay =
              totalQuestions > 0 ? '$score/$totalQuestions' : 'N/A';
          final username = data['username'] ?? 'Unnamed';

          // Check if test already exists, if not add or update if score is higher
          if (!topScorers.containsKey(testName)) {
            topScorers[testName] = {
              'testName': testName,
              'username': username,
              'score': score,
              'scoreDisplay': scoreDisplay,
            };
          } else if (score > topScorers[testName]!['score']) {
            topScorers[testName] = {
              'testName': testName,
              'username': username,
              'score': score,
              'scoreDisplay': scoreDisplay,
            };
          }
        });

        setState(() {
          leaderboardData = topScorers.values.toList();
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
      print("Error fetching leaderboard data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Leaderboard",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF0A2E4D),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // White back button
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: isLeaderboardLoading
          ? const Center(child: CircularProgressIndicator())
          : leaderboardData.isEmpty
              ? const Center(
                  child: Text(
                    "No leaderboard data available",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF0A2E4D),
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: leaderboardData.length,
                  itemBuilder: (context, index) {
                    // Ensure the index is valid
                    if (index >= leaderboardData.length) {
                      return const Center(child: Text("No data available"));
                    }

                    final item = leaderboardData[index];
                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
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
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          title: Text(
                            item['testName'] ?? 'Test Name Unavailable',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            'Username: ${item['username'] ?? 'N/A'}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          trailing: Text(
                            item['scoreDisplay'] ?? 'N/A',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
