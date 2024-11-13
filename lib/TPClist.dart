import 'package:flutter/material.dart';
import 'TPCdetails.dart';

class PlacementOfficerScreen extends StatefulWidget {
  @override
  _PlacementOfficerScreenState createState() => _PlacementOfficerScreenState();
}

class _PlacementOfficerScreenState extends State<PlacementOfficerScreen> {
  final List<Officer> officers = [
    Officer(
      name: 'Aman Sharma',
      email: 'amansharma123@gmail.com',
      imageUrl: 'https://example.com/aman_sharma.jpg', // Replace with actual image URL
    ),
    Officer(
      name: 'TPO',
      email: 'tpo@gmail.com',
      imageUrl: 'https://example.com/tpo.jpg', // Replace with actual image URL
    ),
    Officer(
      name: 'TPO2',
      email: 'tpo2@gmail.com',
      imageUrl: 'https://example.com/tpo2.jpg', // Replace with actual image URL
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Placement Coordinator', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF0A2E4D),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // White back button
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: officers.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(),
                        ),
                      );
                    },
                    child: OfficerCard(officer: officers[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Officer {
  final String name;
  final String email;
  final String imageUrl;

  Officer({
    required this.name,
    required this.email,
    required this.imageUrl,
  });
}

class OfficerCard extends StatelessWidget {
  final Officer officer;

  const OfficerCard({super.key, required this.officer});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(officer.imageUrl),
        ),
        title: Text(officer.name),
        subtitle: Text(officer.email),
      ),
    );
  }
}

class TpcDetails extends StatelessWidget {
  final Officer officer;

  const TpcDetails({super.key, required this.officer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${officer.name} Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 40.0,
              backgroundImage: NetworkImage(officer.imageUrl),
            ),
            SizedBox(height: 16.0),
            Text(
              officer.name,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              officer.email,
              style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}
