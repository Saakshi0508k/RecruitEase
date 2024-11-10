import 'package:flutter/material.dart';
import '/login/loginTPO.dart';
import '/login/loginstudent.dart';
import '/login/loginteacher.dart';
import 'package:recruite_ease/signin/studentsignIN.dart';

class RoleSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Color(0xFF0A2E4D),
      ),
      body: Container(
        color: Color(0xFF0A2E4D),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10),
            // Top right text
            Align(
              alignment: Alignment.topRight,
              child: Text(
                'RecruitEase',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 40),
            // Centered text for role selection
            Text(
              'Choose your Role',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'To help the students to be life ready, not just industry ready.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 40),
            // Role selection cards
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Teacher card
                    SizedBox(
                      width: 150, // Set a fixed width for uniformity
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPageteacher(),
                            ),
                          );
                        },
                        child: RoleCard(
                          imagePath: 'assets/teacher.png',
                          label: 'Teacher',
                        ),
                      ),
                    ),
                    SizedBox(width: 20), // Space between cards
                    // TPC card
                    SizedBox(
                      width: 150, // Set a fixed width for uniformity
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPageTPO(),
                            ),
                          );
                        },
                        child: RoleCard(
                          imagePath: 'assets/student.png',
                          label: 'TPO',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20), // Space before the next line

                SizedBox(
                  width: 150, // Set a fixed width for uniformity
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPagestudent(),
                        ),
                      );
                    },
                    child: RoleCard(
                      imagePath: 'assets/other.png',
                      label: 'Student',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class RoleCard extends StatelessWidget {
  final String imagePath;
  final String label;

  const RoleCard({required this.imagePath, required this.label});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            Image.asset(
              imagePath,
              width: 80,
              height: 80,
            ),
            SizedBox(height: 20),
            Text(
              label,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
