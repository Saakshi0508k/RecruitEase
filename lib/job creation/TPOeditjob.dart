import 'dart:io'; // Required for File class
import 'package:flutter/material.dart';

class TPOEditJob extends StatefulWidget {
  final String jobId; // Declare jobId as a required parameter

  const TPOEditJob({super.key, required this.jobId}); // Use this.jobId to pass the value

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
title: Text(
          'Edit',
          style: TextStyle(color: Colors.white), // White text color
        ),
        backgroundColor: const Color(0xFF0A2E4D),
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 0,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Image Upload Section
                    if (_image != null)
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(_image!),
                        backgroundColor: Colors.grey[200],
                      )
                    else
                      IconButton(
                        icon: Icon(Icons.add_a_photo, color: Colors.grey[600], size: 40),
                        onPressed: _uploadImage,
                      ),
                    const SizedBox(height: 16.0),
                    _buildTextField('Job Title', Icons.title, (value) => _jobTitle = value, initialValue: _jobTitle),
                    _buildTextField('Company Name', Icons.business, (value) => _companyName = value, initialValue: _companyName),
                    _buildTextField('City', Icons.location_city, (value) => _city = value, initialValue: _city),
                    _buildNumberField('Salary', Icons.attach_money, (value) => _salary = int.parse(value), initialValue: _salary.toString()),
                    _buildDropdownField(),
                    _buildTextField('Job Description', Icons.description, (value) => _jobDescription = value, initialValue: _jobDescription, maxLines: 5),
                    const SizedBox(height: 20.0),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Handle job update here, e.g., send data to a server
                          Navigator.pop(context);
                        }
                      },
                      label: const Text('Save Changes', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A2E4D),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, ValueChanged<String> onChanged, {String? initialValue, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        maxLines: maxLines,
        validator: (value) => value == null || value.isEmpty ? 'Please enter $label' : null,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildNumberField(String label, IconData icon, ValueChanged<String> onChanged, {String? initialValue}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) return 'Please enter $label';
          if (int.tryParse(value) == null) return 'Please enter a valid number';
          return null;
        },
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDropdownField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: _jobType,
        items: _jobTypes.map((type) {
          return DropdownMenuItem<String>(
            value: type,
            child: Text(type),
          );
        }).toList(),
        onChanged: (value) => setState(() {
          _jobType = value!;
        }),
        decoration: InputDecoration(
          labelText: 'Job Type',
          prefixIcon: const Icon(Icons.schedule),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }
}
