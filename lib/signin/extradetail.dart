import 'dart:typed_data'; // Import to use Uint8List
import 'dart:io'; // For File usage
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ExtraDetailsPage extends StatefulWidget {
  final String username;
  ExtraDetailsPage({required this.username});

  @override
  _ExtraDetailsPageState createState() => _ExtraDetailsPageState();
}

class _ExtraDetailsPageState extends State<ExtraDetailsPage> {
  // Controllers
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _cgpiController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _yearOfPassingController =
      TextEditingController();
  String _selectedDepartment = '';
  String _selectedClass = '';
  String _selectedYear = '';
  String? _resumeUrl; // Variable to store the resume URL

  // Department, Class and Year lists
  final List<String> departments = ['Computer', 'ECS', 'AI-DS', 'Mechanical'];

  final List<String> classes = ['SE', 'TE', 'BE'];

  final List<String> years = [
    '2024',
    '2025',
    '2026',
    '2027',
  ];

  // Save extra details and resume to Firestore
  Future<void> _saveExtraDetails() async {
    String department = _selectedDepartment;
    String classLevel = _selectedClass;
    String yearOfPassing = _selectedYear;
    String cgpi = _cgpiController.text;
    String skills = _skillsController.text;

    // Check if any of the required fields are empty
    if (department.isEmpty ||
        classLevel.isEmpty ||
        yearOfPassing.isEmpty ||
        cgpi.isEmpty ||
        skills.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please fill in all fields')));
      return;
    }

    try {
      // Update the student document in Firestore with the extra details
      await FirebaseFirestore.instance
          .collection('students')
          .where('username', isEqualTo: widget.username)
          .limit(1)
          .get()
          .then((querySnapshot) async {
        if (querySnapshot.docs.isNotEmpty) {
          String docId = querySnapshot.docs.first.id;

          // Update the extra details for the student
          await FirebaseFirestore.instance
              .collection('students')
              .doc(docId)
              .update({
            'department': department,
            'class': classLevel,
            'yearOfPassing': yearOfPassing,
            'cgpi': cgpi,
            'skills': skills,
            'resumeUrl': _resumeUrl, // Save the resume URL
          });

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Details saved successfully')));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Student not found')));
        }
      });
    } catch (e) {
      print("Error saving extra details: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error saving details')));
    }
  }

  // Method to pick and upload resume
  Future<void> _uploadResume() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      if (kIsWeb) {
        // Handle web platform - use bytes instead of file path
        try {
          Uint8List? fileBytes = result.files.single.bytes; // Fixed here
          if (fileBytes != null) {
            String fileName = result.files.single.name;

            // Upload the file to Firebase Storage using bytes
            Reference storageReference =
                FirebaseStorage.instance.ref().child('resumes/$fileName');
            UploadTask uploadTask =
                storageReference.putData(fileBytes); // Upload using bytes
            TaskSnapshot taskSnapshot = await uploadTask;

            // Get the download URL of the uploaded file
            String downloadUrl = await taskSnapshot.ref.getDownloadURL();

            setState(() {
              _resumeUrl = downloadUrl; // Store the URL of the uploaded resume
            });

            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Resume uploaded successfully')));
          }
        } catch (e) {
          print("Error uploading resume: $e");
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Error uploading resume')));
        }
      } else {
        // Handle non-web platforms (mobile, etc.)
        try {
          String filePath = result.files.single.path!;
          String fileName = result.files.single.name;

          // Upload the file to Firebase Storage
          Reference storageReference =
              FirebaseStorage.instance.ref().child('resumes/$fileName');
          UploadTask uploadTask = storageReference.putFile(File(filePath));
          TaskSnapshot taskSnapshot = await uploadTask;

          // Get the download URL of the uploaded file
          String downloadUrl = await taskSnapshot.ref.getDownloadURL();

          setState(() {
            _resumeUrl = downloadUrl; // Store the URL of the uploaded resume
          });

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Resume uploaded successfully')));
        } catch (e) {
          print("Error uploading resume: $e");
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Error uploading resume')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Extra Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Username: ${widget.username}'),
            // Department Dropdown
            DropdownButtonFormField<String>(
              value: _selectedDepartment.isEmpty ? null : _selectedDepartment,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDepartment = newValue!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Department',
                border: OutlineInputBorder(),
              ),
              items: departments.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            // Class Dropdown
            DropdownButtonFormField<String>(
              value: _selectedClass.isEmpty ? null : _selectedClass,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedClass = newValue!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Class',
                border: OutlineInputBorder(),
              ),
              items: classes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            // Year of Passing Dropdown
            DropdownButtonFormField<String>(
              value: _selectedYear.isEmpty ? null : _selectedYear,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedYear = newValue!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Year of Passing',
                border: OutlineInputBorder(),
              ),
              items: years.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            // CGPI Input Field
            TextField(
              controller: _cgpiController,
              decoration: InputDecoration(labelText: 'CGPI'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            // Skills Input Field
            TextField(
              controller: _skillsController,
              decoration: InputDecoration(labelText: 'Skills'),
            ),
            SizedBox(height: 16),
            // Resume Upload Button
            ElevatedButton(
              onPressed: _uploadResume,
              child: Text('Upload Resume'),
            ),
            SizedBox(height: 16),
            // Save Button
            ElevatedButton(
              onPressed: _saveExtraDetails, // Save the extra details
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
