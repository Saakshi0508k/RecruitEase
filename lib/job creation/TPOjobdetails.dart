import 'package:flutter/material.dart';
import 'TPOeditjob.dart';
import 'studentsAppliedlist.dart';

class TPOJobDetails extends StatelessWidget {
  final String jobId;
  final double Criteria; // Criteria as double
  final String company;
  final String logoUrl;
  final String jobRole;
  final String jobType;
  final int salary;
  final List<String> skills;
  final String jobDescription;

  const TPOJobDetails({
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
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Criteria: ${Criteria.toStringAsFixed(1)}', // Display Criteria as a formatted string
          style: const TextStyle(color: Color(0xFF0A2E4D)),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFF0A2E4D)),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFF0A2E4D)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TPOEditJob(jobId: jobId)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Color(0xFF0A2E4D)),
            onPressed: () {
              _showDeleteConfirmationDialog(context);
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 70,
              backgroundColor: const Color(0xFF0A2E4D),
              backgroundImage: NetworkImage(logoUrl),
            ),
            const SizedBox(height: 20),
            Text(
              jobRole,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0A2E4D),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              company,
              style: const TextStyle(
                fontSize: 20,
                color: Color(0xFF0A2E4D),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StudentAppliedPage(jobId: jobId)),
                );
              },
              child: Card(
                color: const Color(0xFFF7F7F7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.blue,
                            child: const Icon(Icons.person, color: Colors.white, size: 18),
                          ),
                        ],
                      ),
                      Text(
                        'Students Applied',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0A2E4D),
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, color: Color(0xFF0A2E4D), size: 20),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                  color: const Color(0xFFF7F7F7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Role',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0A2E4D),
                          ),
                        ),
                        Text(jobRole, style: const TextStyle(fontSize: 15, color: Color(0xFF0A2E4D))),
                        const SizedBox(height: 12),
                        const Text(
                          'Job Type',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0A2E4D),
                          ),
                        ),
                        Text(jobType, style: const TextStyle(fontSize: 15, color: Color(0xFF0A2E4D))),
                        const SizedBox(height: 12),
                        const Text(
                          'Salary',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0A2E4D),
                          ),
                        ),
                        Text('\$${salary.toString()}', style: const TextStyle(fontSize: 15, color: Color(0xFF0A2E4D))),
                        const SizedBox(height: 12),
                        const Text(
                          'Skills',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0A2E4D),
                          ),
                        ),
                        Text(skills.join(', '), style: const TextStyle(fontSize: 15, color: Color(0xFF0A2E4D))),
                        const SizedBox(height: 12),
                        const Text(
                          'Job Description',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0A2E4D),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          jobDescription,
                          style: const TextStyle(fontSize: 15, color: Color(0xFF0A2E4D)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this job?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel', style: TextStyle(color: Color(0xFF0A2E4D))),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
