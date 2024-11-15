import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardPage extends StatefulWidget {
  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  List<Map<String, dynamic>> leaderboardData = [];
  bool isLeaderboardLoading = true; // Track the loading state

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    fetchLeaderboardData();
  }

  Future<void> fetchLeaderboardData() async {
    try {
      final snapshot = await _firestore
          .collection('mockTestResults')
          .get(); // Get all the results

      if (snapshot.docs.isNotEmpty) {
        Map<String, Map<String, dynamic>> topScorers = {};

        // Loop through all the documents to process the top scorer for each test
        snapshot.docs.forEach((doc) {
          final topScorerDoc = doc.data();
          final testName =
              topScorerDoc['title'] ?? 'N/A'; // Null-aware operator
          final score =
              topScorerDoc['score'] ?? 0; // Default to 0 if score is null
          final answers =
              topScorerDoc['answers'] as List?; // Safely cast to List
          final totalQuestions =
              answers?.length ?? 0; // Safely get length or 0 if answers is null
          final scoreDisplay =
              totalQuestions > 0 ? '$score/$totalQuestions' : 'N/A';
          final username = topScorerDoc['username'] ??
              'Unnamed'; // Default to 'Unnamed' if null

          // Check if this test already has a top scorer, if so, compare scores
          if (!topScorers.containsKey(testName)) {
            topScorers[testName] = {
              'testName': testName,
              'username': username,
              'score': score, // Store raw score here
              'scoreDisplay': scoreDisplay, // Display score when needed
            };
          } else {
            // Update top scorer if the current score is higher
            final currentTopScorer = topScorers[testName];
            if (score > currentTopScorer!['score']) {
              // Compare raw score
              topScorers[testName] = {
                'testName': testName,
                'username': username,
                'score': score, // Store raw score
                'scoreDisplay': scoreDisplay, // Update display score
              };
            }
          }
        });

        // Convert the map of top scorers into a list
        setState(() {
          leaderboardData = topScorers.values.toList();
          isLeaderboardLoading = false; // Set loading to false
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
        title: Text("Leaderboard"),
      ),
      body: isLeaderboardLoading
          ? Center(child: CircularProgressIndicator())
          : leaderboardData.isEmpty
              ? Center(child: Text("No leaderboard data available"))
              : ListView.builder(
                  itemCount: leaderboardData.length,
                  itemBuilder: (context, index) {
                    final leaderboardItem = leaderboardData[index];
                    return ListTile(
                      title: Text(leaderboardItem['testName']),
                      subtitle:
                          Text('Username: ${leaderboardItem['username']}'),
                      trailing:
                          Text('Score: ${leaderboardItem['scoreDisplay']}'),
                    );
                  },
                ),
    );
  }
}
