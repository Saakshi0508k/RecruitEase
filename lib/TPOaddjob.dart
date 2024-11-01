import 'dart:io'; // Required for File class
import 'package:flutter/material.dart';

class AddJobPage extends StatefulWidget {
  const AddJobPage({super.key});

  @override
  _AddJobPageState createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  final _formKey = GlobalKey<FormState>();

  String _jobTitle = '';
  String _companyName = '';
  String _city = '';
  int _salary = 0;
  String _jobType = 'Full Time';
  String _jobDescription = '';
  String _jobRole = ''; // New variable for Job Role
  String _skills = ''; // New variable for Skills
  File? _image; // Change from XFile to File for local storage

  final List<String> _jobTypes = ['Full Time', 'Part Time', 'Contract'];

  // Placeholder function for image upload
  Future<void> _uploadImage() async {
    // Here, implement your logic for image upload (e.g., from a file picker)
    // For demonstration, we'll just simulate selecting an image
    setState(() {
      // Simulate an image being selected
      _image = File('path/to/your/image.png'); // Replace with actual image path
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Job'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Image Upload
                if (_image != null)
                  Image.file(
                    _image!,
                    height: 150,
                  ),
                ElevatedButton(
                  onPressed: _uploadImage,
                  child: const Text('Upload Image'),
                ),

                const SizedBox(height: 16.0),

                // Job Title
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Job Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a job title';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _jobTitle = value;
                  },
                ),

                // Company Name
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Company Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a company name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _companyName = value;
                  },
                ),

                // City
                TextFormField(
                  decoration: const InputDecoration(labelText: 'City'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a city';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _city = value;
                  },
                ),

                // Salary
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Salary'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a salary';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _salary = int.parse(value);
                  },
                ),

                // Job Type
                DropdownButtonFormField<String>(
                  value: _jobType,
                  items: _jobTypes.map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _jobType = value!;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Job Type'),
                ),

                // Job Role
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Job Role'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a job role';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _jobRole = value;
                  },
                ),

                // Skills
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Skills (comma separated)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter required skills';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _skills = value;
                  },
                ),

                // Job Description
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Job Description'),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a job description';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _jobDescription = value;
                  },
                ),

                const SizedBox(height: 16.0),

                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Handle job creation here, e.g., send data to a server
                      // You can also navigate back to the previous screen
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('NEXT'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
