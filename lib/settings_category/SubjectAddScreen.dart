import 'package:flutter/material.dart';
import 'package:term_project/inapp_algorithm/SubjectData.dart';
import 'package:term_project/DataManager.dart';

class SubjectAddScreen extends StatefulWidget {
  final List<SubjectData> subjectList; // List of existing subjects
  final SubjectData? existingSubject; // Check if editing an existing subject

  SubjectAddScreen({required this.subjectList, this.existingSubject});

  @override
  _SubjectAddScreenState createState() => _SubjectAddScreenState();
}

class _SubjectAddScreenState extends State<SubjectAddScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool isMajor = false; // Major status
  int credit = 1; // Credit hours
  int preference = 1; // Preference level (1-5)
  double attendanceRatio = 0.0;
  double midExamRatio = 0.0;
  double finalExamRatio = 0.0;
  double assignmentRatio = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.existingSubject != null) {
      final subject = widget.existingSubject!;
      _nameController.text = subject.subjectName;
      isMajor = subject.isMajor;
      credit = subject.creditHours;
      preference = subject.preferenceLevel;
      attendanceRatio = subject.attendanceRatio;
      midExamRatio = subject.midtermRatio;
      finalExamRatio = subject.finalRatio;
      assignmentRatio = subject.assignmentRatio;
    }
  }

  void _saveSubject() async {
    // Ensure the total ratio equals 1.0
    if ((attendanceRatio + midExamRatio + finalExamRatio + assignmentRatio)
        .toStringAsFixed(2) !=
        "1.00") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('The total weight ratios must sum to 1.0.')),
      );
      return;
    }

    final newSubject = SubjectData(
      subjectName: _nameController.text.trim(),
      isMajor: isMajor,
      creditHours: credit,
      preferenceLevel: preference,
      attendanceRatio: attendanceRatio,
      midtermRatio: midExamRatio,
      finalRatio: finalExamRatio,
      assignmentRatio: assignmentRatio,
    );

    // Add the new or updated subject to the list
    widget.subjectList.add(newSubject);

    // Save the list to JSON
    await DataManager.saveSubjects(widget.subjectList);

    // Close the screen and pass back the new subject
    Navigator.pop(context, newSubject);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingSubject == null ? 'Add Subject' : 'Edit Subject'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subject name input
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Subject Name'),
            ),
            // Major status toggle
            SwitchListTile(
              title: Text('Is Major'),
              value: isMajor,
              onChanged: (value) {
                setState(() {
                  isMajor = value;
                });
              },
            ),
            // Credit hours dropdown
            DropdownButtonFormField<int>(
              decoration: InputDecoration(labelText: 'Credits'),
              value: credit,
              items: List.generate(
                3,
                    (index) => DropdownMenuItem(
                  value: index + 1,
                  child: Text('${index + 1} Credit(s)'),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  credit = value ?? 1;
                });
              },
            ),
            // Preference level (star rating)
            Row(
              children: [
                Text('Preference'),
                Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    5,
                        (index) => IconButton(
                      icon: Icon(
                        index < preference ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      ),
                      onPressed: () {
                        setState(() {
                          preference = index + 1;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Grade ratios
            Text(
              'Enter Grade Ratios (Total must equal 1.0)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildRatioInput(
              label: 'Attendance Ratio',
              onChanged: (value) {
                setState(() {
                  attendanceRatio = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            _buildRatioInput(
              label: 'Midterm Ratio',
              onChanged: (value) {
                setState(() {
                  midExamRatio = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            _buildRatioInput(
              label: 'Final Exam Ratio',
              onChanged: (value) {
                setState(() {
                  finalExamRatio = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            _buildRatioInput(
              label: 'Assignment Ratio',
              onChanged: (value) {
                setState(() {
                  assignmentRatio = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            SizedBox(height: 20),
            // Save button
            Center(
              child: ElevatedButton(
                onPressed: _saveSubject,
                child: Text(widget.existingSubject == null ? 'Add Subject' : 'Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatioInput({
    required String label,
    required Function(String) onChanged,
  }) {
    return TextField(
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      onChanged: onChanged,
    );
  }
}
