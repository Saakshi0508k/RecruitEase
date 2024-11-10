import 'dart:io'; // Required for File class
import 'package:flutter/material.dart';

class TPOEditJob extends StatefulWidget {
  final String jobId; // Declare jobId as a required parameter

  const TPOEditJob(
      {super.key, required this.jobId}); // Use this.jobId to pass the value

  @override
  _TPOEditJobState createState() => _TPOEditJobState();
}

class _TPOEditJobState extends State<TPOEditJob> {
  final _formKey = GlobalKey<FormState>();

  String _jobTitle = '';
  String _companyName = '';
  String _city = '';
  int _salary = 0;
  String _jobType = 'Full Time';
  String _jobDescription = '';
  File? _image; // Change from XFile to File for local storage

  final List<String> _jobTypes = ['Full Time', 'Part Time', 'Contract'];

  @override
  void initState() {
    super.initState();
    // Initialize any state variables or fetch job details based on jobId here
    print("Editing job with ID: ${widget.jobId}");
  }

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
        title: const Text('Edit Job'),
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
                  initialValue: _jobTitle,
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
                  initialValue: _companyName,
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
                  initialValue: _city,
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
                  initialValue: _salary.toString(),
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
                    _salary = int.tryParse(value) ?? 0;
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

                // Job Description
                TextFormField(
                  initialValue: _jobDescription,
                  decoration:
                      const InputDecoration(labelText: 'Job Description'),
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
                      // Handle job update here, e.g., send data to a server
                      // You can also navigate back to the previous screen
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
