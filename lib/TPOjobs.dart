import 'package:flutter/material.dart';
import 'TPOaddjob.dart';
import 'TPOjobdetails.dart'; // Make sure to import the job details page

class JobsPage extends StatefulWidget {
  const JobsPage({super.key});

  @override
  _JobsPageState createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  final List<Job> _jobs = [
    Job(
      title: 'Software Engineer I',
      company: 'JPMorgan Chase Bank',
      logoUrl: 'https://example.com/jpmorgan_logo.png',
    ),
    Job(
      title: 'ETP SAP Consultant',
      company: 'Deloitte',
      logoUrl: 'https://example.com/jpmorgan_logo.png',
    ),
    Job(
      title: 'Software Developer',
      company: 'Wipro',
      logoUrl: 'https://example.com/jpmorgan_logo.png',
    ),
    // Add more jobs here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jobs'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (value) {
                // Implement search functionality here
              },
            ),

            const SizedBox(height: 16.0),

            // Job List
            Expanded(
              child: ListView.builder(
                itemCount: _jobs.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Navigate to the job details page when the card is tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TPOJobDetails(
                            title: _jobs[index].title,
                            company: _jobs[index].company,
                            logoUrl: _jobs[index].logoUrl,
                          ),
                        ),
                      );
                    },
                    child: JobCard(
                      title: _jobs[index].title,
                      company: _jobs[index].company,
                      logoUrl: _jobs[index].logoUrl,
                    ),
                  );
                },
              ),
            ),

            // Add Job Button
            ElevatedButton(
              onPressed: () {
                // Handle add job button press
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddJobPage(), // Replace with your AddJobPage
                  ),
                );
              },
              child: const Text('Add Job'),
            ),
          ],
        ),
      ),
    );
  }
}

class Job {
  final String title;
  final String company;
  final String logoUrl;

  const Job({
    required this.title,
    required this.company,
    required this.logoUrl,
  });
}

class JobCard extends StatelessWidget {
  final String title;
  final String company;
  final String logoUrl;

  const JobCard({
    super.key,
    required this.title,
    required this.company,
    required this.logoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(logoUrl),
        ),
        title: Text(title),
        subtitle: Text(company),
        // Removed the trailing IconButton for delete functionality
      ),
    );
  }
}
