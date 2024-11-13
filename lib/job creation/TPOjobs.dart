import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'TPOjobdetails.dart';
import 'TPOaddjob.dart';

class JobsPage extends StatefulWidget {
  const JobsPage({super.key});

  @override
  _JobsPageState createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Jobs',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
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

            // Job List using StreamBuilder
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('jobs').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No jobs available"));
                  }

                  final jobs = snapshot.data!.docs.map((doc) {
                    return Job(
                      jobId: doc.id,
                      title: doc['jobTitle'] ?? '',
                      company: doc['companyName'] ?? '',
                      logoUrl: doc['imageUrl'] ?? '',
                      jobRole: doc['jobRole'] ?? '',
                      jobType: doc['jobType'] ?? '',
                      salary: doc['salary'] ?? 0,
                      skills: List<String>.from(
                        (doc['skills'] is List) ? doc['skills'] : [doc['skills'] ?? ''],
                      ),
                      jobDescription: doc['jobDescription'] ?? '',
                    );
                  }).toList();

                  return ListView.builder(
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TPOJobDetails(
                                jobId: jobs[index].jobId,
                                title: jobs[index].title,
                                company: jobs[index].company,
                                logoUrl: jobs[index].logoUrl,
                                jobRole: jobs[index].jobRole,
                                jobType: jobs[index].jobType,
                                salary: jobs[index].salary,
                                skills: jobs[index].skills,
                                jobDescription: jobs[index].jobDescription,
                              ),
                            ),
                          );
                        },
                        child: JobCard(
                          jobId: jobs[index].jobId,
                          title: jobs[index].title,
                          company: jobs[index].company,
                          logoUrl: jobs[index].logoUrl,
                          jobRole: jobs[index].jobRole,
                          jobType: jobs[index].jobType,
                          salary: jobs[index].salary,
                          skills: jobs[index].skills,
                          jobDescription: jobs[index].jobDescription,
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddJobPage(),
            ),
          );
        },
        backgroundColor: Color(0xFF0A2E4D), // Set button color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Square shape with rounded corners
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Align to bottom-right
    );
  }
}

// Job and JobCard classes remain unchanged
// ... Rest of the code for Job and JobCard class


class Job {
  final String jobId;
  final String title;
  final String company;
  final String logoUrl;
  final String jobRole;
  final String jobType;
  final int salary;
  final List<String> skills;
  final String jobDescription;

  const Job({
    required this.jobId,
    required this.title,
    required this.company,
    required this.logoUrl,
    required this.jobRole,
    required this.jobType,
    required this.salary,
    required this.skills,
    required this.jobDescription,
  });
}

class JobCard extends StatelessWidget {
  final String jobId;
  final String title;
  final String company;
  final String logoUrl;
  final String jobRole;
  final String jobType;
  final int salary;
  final List<String> skills;
  final String jobDescription;

  const JobCard({
    super.key,
    required this.jobId,
    required this.title,
    required this.company,
    required this.logoUrl,
    required this.jobRole,
    required this.jobType,
    required this.salary,
    required this.skills,
    required this.jobDescription,
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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TPOJobDetails(
                jobId: jobId,
                title: title,
                company: company,
                logoUrl: logoUrl,
                jobRole: jobRole,
                jobType: jobType,
                salary: salary,
                skills: skills,
                jobDescription: jobDescription,
              ),
            ),
          );
        },
      ),
    );
  }
}
