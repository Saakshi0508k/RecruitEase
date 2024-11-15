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
  final List<String> _departments = ['Computer', 'AI-DS', 'ECS', 'Mechanical'];
  List<String> _selectedDepartments = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  double _Criteria = 0.0; // Change Criteria type to double
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
        final jobDocRef = _firestore.collection('jobs').doc();
        final jobId = jobDocRef.id;

        String? imageUrl;
        if (_imageData != null) {
          final storageRef = _storage.ref().child('job_images/$jobId');
          await storageRef.putData(_imageData!);
          imageUrl = await storageRef.getDownloadURL();
        }

        await jobDocRef.set({
          'jobId': jobId,
          'Criteria': _Criteria, // Save Criteria as double
          'companyName': _companyName,
          'city': _city,
          'salary': _salary,
          'jobType': _jobType,
          'jobDescription': _jobDescription,
          'jobRole': _jobRole,
          'skills': _skills,
          'departments': _selectedDepartments, // Save selected departments
          'imageUrl': imageUrl,
          'createdAt': Timestamp.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Job added successfully')),
        );
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
                    if (_imageData != null)
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: MemoryImage(_imageData!),
                        backgroundColor: Colors.grey[200],
                      )
                    else
                      IconButton(
                        icon: Icon(Icons.add_a_photo,
                            color: Colors.grey[600], size: 40),
                        onPressed: _uploadImage,
                      ),
                    const SizedBox(height: 16.0),
                    _buildDoubleField(
                        'Criteria',
                        Icons.circle_notifications_rounded,
                        (value) => _Criteria = value),
                    const Text('Department', style: TextStyle(fontSize: 16)),
                    ..._departments.map((department) {
                      return CheckboxListTile(
                        title: Text(department),
                        value: _selectedDepartments.contains(department),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              _selectedDepartments.add(department);
                            } else {
                              _selectedDepartments.remove(department);
                            }
                          });
                        },
                      );
                    }).toList(),
                    _buildTextField('Company Name', Icons.business,
                        (value) => _companyName = value),
                    _buildTextField(
                        'City', Icons.location_city, (value) => _city = value),
                    _buildNumberField('Salary', Icons.attach_money,
                        (value) => _salary = int.parse(value)),
                    _buildDropdownField(),
                    _buildTextField(
                        'Job Role', Icons.work, (value) => _jobRole = value),
                    _buildTextField('Skills (comma separated)', Icons.code,
                        (value) => _skills = value),
                    _buildTextField('Job Description', Icons.description,
                        (value) => _jobDescription = value,
                        maxLines: 4),
                    const SizedBox(height: 20.0),
                    ElevatedButton.icon(
                      onPressed: _saveJob,
                      label: const Text('Save Job',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A2E4D),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
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

  Widget _buildTextField(
      String label, IconData icon, ValueChanged<String> onChanged,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
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
        validator: (value) =>
            value == null || value.isEmpty ? 'Please enter $label' : null,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDoubleField(
      String label, IconData icon, ValueChanged<double> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Please enter $label';
          if (double.tryParse(value) == null)
            return 'Please enter a valid number';
          return null;
        },
        onChanged: (value) => onChanged(double.tryParse(value) ?? 0.0),
      ),
    );
  }

  Widget _buildNumberField(
      String label, IconData icon, ValueChanged<String> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
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
