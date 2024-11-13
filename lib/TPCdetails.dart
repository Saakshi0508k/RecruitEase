import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0A2E4D)), // Back button in Color(0xFF0A2E4D)
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name, Title, and Profile Icon Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Aman Sharma',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0A2E4D),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Senior Software Engineer',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF0A2E4D),
                        ),
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 70,
                    backgroundColor: Color(0xFF0A2E4D),
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Floating Details and Biography Block
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Details',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color:  Color(0xFF0A2E4D),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Two-Column Details Layout
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // First Column
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Mobile',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color:  Color(0xFF0A2E4D),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '9852364752',
                              style: TextStyle(fontSize: 20,color: Color(0xFF0A2E4D)),
                            ),
                            SizedBox(height: 16),

                            Text(
                              'Qualification',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0A2E4D),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'B.Tech in Computer Science',
                              style: TextStyle(color: Color(0xFF0A2E4D)),
                            ),
                            SizedBox(height: 16),

                            Text(
                              'Date of Birth',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0A2E4D),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '12 March 1995',
                              style: TextStyle(color: Color(0xFF0A2E4D)),
                            ),
                          ],
                        ),
                        
                        // Second Column
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Gender',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0A2E4D),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Male',
                              style: TextStyle(color: Color(0xFF0A2E4D)),
                            ),
                            SizedBox(height: 16),

                            Text(
                              'Stream',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0A2E4D),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Computer Science',
                              style: TextStyle(color: Color(0xFF0A2E4D)),
                            ),
                            SizedBox(height: 16),

                            Text(
                              'Experience',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0A2E4D),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '5 Years',
                              style: TextStyle(color: Color(0xFF0A2E4D)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),

                    // Biography Section inside the Container
                    const Text(
                      'Biography',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A2E4D),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Aman Sharma is a seasoned software engineer specializing in application development and backend systems. '
                      'With a background in computer science and extensive experience in various technologies, he has consistently '
                      'delivered high-quality, scalable solutions. Aman is passionate about learning new programming languages '
                      'and applying innovative solutions to challenging projects.',
                      style: TextStyle(color: Color(0xFF0A2E4D)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
