import 'package:flutter/material.dart';

class LandingPageTeacher extends StatefulWidget {
  const LandingPageTeacher({super.key});

  @override
  _LandingPageTeacherState createState() => _LandingPageTeacherState();
}

class _LandingPageTeacherState extends State<LandingPageTeacher> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Prevents back arrow
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Greeting Text on the left
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Hello',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Sakshi Kupekar',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            // Profile Picture on the right
            CircleAvatar(
              radius: 20, // Adjust size as needed
              backgroundImage: AssetImage(
                  'assets/profile_pic.jpg'), // Path to your profile picture
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15), // Adjust this value as needed
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Insight drives impact',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Know the role, know the company',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'make your mark.',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40), // Space between the box and title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: const Text(
                'For You',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 10), // Space between the title and carousel
            // First Carousel Section
            Container(
              height: 230,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCarouselItem('Item 1', Colors.red),
                  _buildCarouselItem('Item 2', Colors.green),
                  _buildCarouselItem('Item 3', Colors.blue),
                ],
              ),
            ),
            const SizedBox(height: 30), // Space between carousels
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: const Text(
                'Upcoming Opportunities',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 10), // Space between the title and carousel
            // Second Carousel Section
            Container(
              height: 230,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCarouselItem('Opportunity 1', Colors.orange),
                  _buildCarouselItem('Opportunity 2', Colors.purple),
                  _buildCarouselItem('Opportunity 3', Colors.teal),
                ],
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

  Widget _buildCarouselItem(String title, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 200,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
