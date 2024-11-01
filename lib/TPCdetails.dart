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
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Aman Sharma'),
                  // Add an icon or logo here
                ],
              ),

              // Profile Picture and Name
              const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://example.com/profile_pic.jpg'),
              ),
              const Text('Senior Software Engineer'),

              // Contact Information
              const ListTile(
                leading: Icon(Icons.email),
                title: Text('amansharma123@gm.....'),
              ),
              const ListTile(
                leading: Icon(Icons.phone),
                title: Text('9852364752'),
              ),

              // Social Media Links
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Add icons for social media platforms with links
                ],
              ),

              // Skills, Experience, Education, Projects, and Certifications
              // Use similar layouts as the contact information and social media links
              // You can use ListView.builder to dynamically populate lists based on data

            ],
          ),
        ),
      ),
    );
  }
}
