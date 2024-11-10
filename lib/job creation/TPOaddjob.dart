import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AddJobPage extends StatefulWidget {
  const AddJobPage({super.key});

  @override
  _AddJobPageState createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String _jobTitle = '';
  String _companyName = '';
  String _city = '';
  int _salary = 0;
  String _jobType = 'Full Time';
  String _jobDescription = '';
  String _jobRole = '';
  String _skills = '';
  Uint8List? _imageData;

  final List<String> _jobTypes = [
    'Full Time',
    'Part Time',
    'Contract',
    'Internship'
  ];

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageData = await pickedFile.readAsBytes();
      setState(() {
        _imageData = imageData;
      });
    }
  }

  Future<void> _saveJob() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Generate a unique job ID
        final jobDocRef = _firestore.collection('jobs').doc();
        final jobId = jobDocRef.id;

        // Upload image to Firebase Storage if it exists
        String? imageUrl;
        if (_imageData != null) {
          final storageRef = _storage.ref().child('job_images/$jobId');
          await storageRef.putData(_imageData!);
          imageUrl = await storageRef.getDownloadURL();
        }

        // Save job data to Firestore with the unique jobId
        await jobDocRef.set({
          'jobId': jobId, // Store the unique jobId in the document
          'jobTitle': _jobTitle,
          'companyName': _companyName,
          'city': _city,
          'salary': _salary,
          'jobType': _jobType,
          'jobDescription': _jobDescription,
          'jobRole': _jobRole,
          'skills': _skills,
          'imageUrl': imageUrl,
          'createdAt': Timestamp.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Job added successfully')),
        );

        // Navigate to the next page and pass the jobId
        Navigator.pop(context, jobId);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
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
                if (_imageData != null)
                  Image.memory(
                    _imageData!,
                    height: 150,
                  ),
                ElevatedButton(
                  onPressed: _uploadImage,
                  child: const Text('Upload Image'),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Job Title'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a job title'
                      : null,
                  onChanged: (value) => _jobTitle = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Company Name'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a company name'
                      : null,
                  onChanged: (value) => _companyName = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'City'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a city'
                      : null,
                  onChanged: (value) => _city = value,
                ),
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
                  onChanged: (value) => _salary = int.parse(value),
                ),
                DropdownButtonFormField<String>(
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
                  decoration: const InputDecoration(labelText: 'Job Type'),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Job Role'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a job role'
                      : null,
                  onChanged: (value) => _jobRole = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Skills (comma separated)'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter required skills'
                      : null,
                  onChanged: (value) => _skills = value,
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Job Description'),
                  maxLines: 5,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a job description'
                      : null,
                  onChanged: (value) => _jobDescription = value,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _saveJob,
                  child: const Text('Save Job'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
