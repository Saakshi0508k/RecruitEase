import 'package:flutter/material.dart';
import 'studentsAppliedlist.dart'; // Assuming you have this page for students to see applied jobs

class SkillsDisplay extends StatelessWidget {
  final List<String> skills;

  SkillsDisplay({required this.skills});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0, // Space between skill tags
      runSpacing: 8.0, // Space between rows
      children: skills.map((skill) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
          decoration: BoxDecoration(
            color:
                Colors.blue.shade50, // Background color similar to your example
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Text(
            skill,
            style: TextStyle(
              color: Color(0xFF0A2E4D), // Text color
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class StudentJobDetails extends StatelessWidget {
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

  const StudentJobDetails({
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
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFF0A2E4D)),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF0A2E4D),
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(logoUrl),
                    fit: BoxFit.contain,
                  ),
                ),
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
              Container(
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
                        Text(jobRole,
                            style: const TextStyle(
                                fontSize: 15, color: Color(0xFF0A2E4D))),
                        const SizedBox(height: 12),
                        const Text(
                          'Criteria',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0A2E4D),
                          ),
                        ),
                        Text(
                          '${Criteria.toStringAsFixed(1)}',
                          style: const TextStyle(
                              fontSize: 15, color: Color(0xFF0A2E4D)),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Department',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0A2E4D),
                          ),
                        ),
                        Wrap(
                          spacing: 8.0,
                          children: departments.map((dept) {
                            return Chip(
                              label: Text(
                                dept,
                                style:
                                    const TextStyle(color: Color(0xFF0A2E4D)),
                              ),
                              backgroundColor: Colors.blue.shade50,
                            );
                          }).toList(),
                        ),
                        const Text(
                          'Job Type',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0A2E4D),
                          ),
                        ),
                        Text(jobType,
                            style: const TextStyle(
                                fontSize: 15, color: Color(0xFF0A2E4D))),
                        const SizedBox(height: 12),
                        const Text(
                          'Salary',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0A2E4D),
                          ),
                        ),
                        Text(
                          '₹${salary.toString()}',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF0A2E4D),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Skills',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0A2E4D),
                          ),
                        ),
                        SkillsDisplay(skills: skills),
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
                          style: const TextStyle(
                              fontSize: 15, color: Color(0xFF0A2E4D)),
                        ),
                        const SizedBox(height: 20),
                        // Apply Button
                        ElevatedButton(
                          onPressed: () {
                            // Show the Snackbar when Apply button is pressed
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Application Successful'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF0A2E4D),
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Apply',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
