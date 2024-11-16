import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'studentjobdetails.dart';

class StudentJobPage extends StatefulWidget {
  final String studentUsername;

  const StudentJobPage({
    super.key,
    required this.studentUsername,
  });

  @override
  _StudentJobPageState createState() => _StudentJobPageState();
}

class _StudentJobPageState extends State<StudentJobPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _filterByDepartment = false;
  bool _filterByCriteria = false;

  String studentDepartment = '';
  double studentCGPI = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchStudentData();
  }

  // Fetch student data (department and CGPI) from Firebase
  Future<void> _fetchStudentData() async {
    try {
      // Query to find the student document based on the username field
      final studentQuerySnapshot = await FirebaseFirestore.instance
          .collection('students') // Adjust collection name as needed
          .where('username', isEqualTo: widget.studentUsername)
          .limit(1) // Ensure only one document is returned
          .get();

      if (studentQuerySnapshot.docs.isNotEmpty) {
        final studentDoc = studentQuerySnapshot.docs.first;
        setState(() {
          studentDepartment = studentDoc['department'] ?? '';
          studentCGPI = (studentDoc['cgpi'] as num?)?.toDouble() ?? 0.0;
        });
      }
    } catch (e) {
      print('Error fetching student data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Jobs',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0A2E4D),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
            const SizedBox(height: 16.0),

            // Filters: Department and Criteria
            Row(
              children: [
                Checkbox(
                  value: _filterByDepartment,
                  onChanged: (value) {
                    setState(() {
                      _filterByDepartment = value!;
                    });
                  },
                ),
                const Text('Department'),
                const SizedBox(width: 20),
                Checkbox(
                  value: _filterByCriteria,
                  onChanged: (value) {
                    setState(() {
                      _filterByCriteria = value!;
                    });
                  },
                ),
                const Text('CGPI'),
              ],
            ),

            const SizedBox(height: 16.0),

            // Job List using StreamBuilder
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('jobs').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No jobs available"));
                  }

                  // Filter jobs based on department, criteria, and search query
                  final jobs = snapshot.data!.docs
                      .map((doc) => Job(
                            jobId: doc.id,
                            Criteria:
                                (doc['Criteria'] as num?)?.toDouble() ?? 0.0,
                            company: doc['companyName'] ?? '',
                            logoUrl: doc['imageUrl'] ?? '',
                            jobRole: doc['jobRole'] ?? '',
                            jobType: doc['jobType'] ?? '',
                            salary: doc['salary'] ?? 0,
                            skills: List<String>.from((doc['skills'] is List)
                                ? doc['skills']
                                : [doc['skills'] ?? '']),
                            jobDescription: doc['jobDescription'] ?? '',
                            departments:
                                List<String>.from(doc['departments'] ?? []),
                          ))
                      .where((job) =>
                          // Match search query
                          (job.jobRole.toLowerCase().contains(_searchQuery) ||
                              job.company
                                  .toLowerCase()
                                  .contains(_searchQuery)) &&
                          // Filter by department if checkbox is checked
                          (!_filterByDepartment ||
                              job.departments
                                  .map((d) => d.toLowerCase())
                                  .contains(studentDepartment.toLowerCase())) &&
                          // Filter by criteria if checkbox is checked
                          (!_filterByCriteria || job.Criteria <= studentCGPI))
                      .toList();

                  if (jobs.isEmpty) {
                    return const Center(
                        child: Text("No jobs match your filters or search"));
                  }

                  return ListView.builder(
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => StudentJobDetails(
                                jobId: jobs[index].jobId,
                                Criteria: jobs[index].Criteria,
                                company: jobs[index].company,
                                logoUrl: jobs[index].logoUrl,
                                jobRole: jobs[index].jobRole,
                                jobType: jobs[index].jobType,
                                salary: jobs[index].salary,
                                skills: jobs[index].skills,
                                jobDescription: jobs[index].jobDescription,
                                departments: jobs[index].departments,
                              ),
                            ),
                          );
                        },
                        child: JobCard(
                          jobId: jobs[index].jobId,
                          Criteria: jobs[index].Criteria,
                          company: jobs[index].company,
                          logoUrl: jobs[index].logoUrl,
                          jobRole: jobs[index].jobRole,
                          jobType: jobs[index].jobType,
                          salary: jobs[index].salary,
                          skills: jobs[index].skills,
                          jobDescription: jobs[index].jobDescription,
                          departments: jobs[index].departments,
                        ),
                      );
                    },
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

// Job Model
class Job {
  final String jobId;
  final double Criteria;
  final String company;
  final String logoUrl;
  final String jobRole;
  final String jobType;
  final int salary;
  final List<String> skills;
  final String jobDescription;
  final List<String> departments;

  const Job({
    required this.jobId,
    required this.Criteria,
    required this.company,
    required this.logoUrl,
    required this.jobRole,
    required this.jobType,
    required this.salary,
    required this.skills,
    required this.jobDescription,
    required this.departments,
  });
}

// Job Card Widget
class JobCard extends StatelessWidget {
  final String jobId;
  final double Criteria;
  final String company;
  final String logoUrl;
  final String jobRole;
  final String jobType;
  final int salary;
  final List<String> skills;
  final String jobDescription;
  final List<String> departments;

  const JobCard({
    super.key,
    required this.jobId,
    required this.Criteria,
    required this.company,
    required this.logoUrl,
    required this.jobRole,
    required this.jobType,
    required this.salary,
    required this.skills,
    required this.jobDescription,
    required this.departments,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(logoUrl),
          radius: 40,
        ),
        title: Text(jobRole),
        subtitle: Text(company),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => StudentJobDetails(
                jobId: jobId,
                Criteria: Criteria,
                company: company,
                logoUrl: logoUrl,
                jobRole: jobRole,
                jobType: jobType,
                salary: salary,
                skills: skills,
                jobDescription: jobDescription,
                departments: departments,
              ),
            ),
          );
        },
      ),
    );
  }
}
