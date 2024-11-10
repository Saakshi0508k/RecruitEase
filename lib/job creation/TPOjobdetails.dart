import 'package:flutter/material.dart';

class TPOJobDetails extends StatelessWidget {
  final String jobId;
  final String title;
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
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(logoUrl),
            const SizedBox(height: 10),
            Text('Company: $company', style: TextStyle(fontSize: 18)),
            Text('Role: $jobRole', style: TextStyle(fontSize: 18)),
            Text('Job Type: $jobType', style: TextStyle(fontSize: 18)),
            Text('Salary: \$${salary.toString()}',
                style: TextStyle(fontSize: 18)),
            Text('Skills: ${skills.join(', ')}',
                style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Text(
              'Job Description: $jobDescription',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}
